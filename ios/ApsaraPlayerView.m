#import "ApsaraPlayerView.h"

@interface ApsaraPlayerView ()
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) AVPVidStsSource *stsSource;
@end

@implementation ApsaraPlayerView
{
  NSDictionary *_options;
  BOOL _paused;
  BOOL _prepared;
  NSString *_vid;
  AliMediaDownloader *_downloader;
  RCTPromiseResolveBlock _downloaderResolver;
  RCTPromiseRejectBlock _downloaderRejector;
}

- (void) layoutSubviews {
  [super layoutSubviews];
  for (UIView* view in self.subviews) {
    [view setFrame: self.bounds];
  }
}

- (void) dealloc {
  if (_player) {
    [_player destroy];
    _player = nil;
  }
}

- (AliPlayer *)player {
  if (!_player) {
    _player = [[AliPlayer alloc] init];
    _player.autoPlay = NO;
    _player.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT;
    _player.rate = 1;
    _player.delegate = self;
    _player.playerView = self.playerView;
    [self addSubview: self.playerView];
  }
  return _player;
}

- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
    }
    return _playerView;
}

- (void)setVid: (NSString *)vid {
  _vid = vid;
  if (_prepared != YES && vid != nil && ![vid isEqualToString:@""]) {
    [self setupPlayer];
  }
}

- (void)setOptions: (NSDictionary *)opts {
  _options = opts;
  [self setupPlayer];
}

- (void)setupPlayer {
  if (_vid == nil || [_vid isEqualToString:@""]) {
    return;
  }

  [self addSubview: self.player.playerView];

  NSString *type = [_options objectForKey:@"type"];
  if ([type isEqualToString:@"vidSts"]) {
    [_player setStsSource:self.stsSource];
  } else if ([type isEqualToString:@"playAuth"]) {
    AVPVidAuthSource *source = [[AVPVidAuthSource alloc] init];
    source.vid = _vid;
    source.region = @"";
    source.playAuth = _options[@"playAuth"];

    [_player setAuthSource:source];
  }

  [_player prepare];
  _prepared = YES;

  if (!_paused) {
    _player.autoPlay = YES;
  }
}

- (void)setPaused:(BOOL)paused {
  if (paused) {
    [_player pause];
  } else {
    [_player start];
  }

  _paused = paused;
}

- (void)setSeek: (float)seek {
  [_player seekToTime:seek seekMode:AVP_SEEKMODE_INACCURATE];
}

- (void)setMuted: (bool)muted {
  _player.muted = muted;
}

- (void)setVolume: (float)volume {
  _player.volume = volume;
}

- (void)setRepeat: (bool)repeat {
  _player.loop = repeat;
}

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

- (AVPVidStsSource *) stsSource {
  if (!_stsSource) {
    _stsSource = [[AVPVidStsSource alloc] init];
    _stsSource.vid = _vid;
    _stsSource.region = _options[@"region"];
    _stsSource.securityToken = _options[@"securityToken"];
    _stsSource.accessKeyId = _options[@"accessKeyId"];
    _stsSource.accessKeySecret = _options[@"accessKeySecret"];
  }

  return _stsSource;
}

-(void)onPlayerEvent:(AliPlayer*)player eventType:(AVPEventType)eventType {
  switch (eventType) {
    case AVPEventPrepareDone:
      if (self.onVideoLoad) {
        self.onVideoLoad(@{
          @"duration": [NSNumber numberWithFloat:_player.duration],
          @"currentPosition": [NSNumber numberWithFloat:_player.currentPosition]});
      }
      break;
    case AVPEventSeekEnd:
      if (self.onVideoSeek) {
        self.onVideoSeek(@{
          @"currentTime": [NSNumber numberWithFloat:_player.currentPosition]});
      }
      break;
    // case ...
    default:
      break;
  }
}

- (void)onCurrentPositionUpdate:(AliPlayer*)player position:(int64_t)position {
  if (self.onVideoProgress) {
    self.onVideoProgress(@{@"currentTime": [NSNumber numberWithFloat:position]});
  }
}

- (void)onError:(id)instance errorModel:(AVPErrorModel *)errorModel {
  if ([instance isKindOfClass:[AliPlayer class]]) {
    AliPlayer *player = (AliPlayer *)instance;
    [player stop];
    if (self.onVideoError) {
      self.onVideoError(@{
        @"message": errorModel.message,
        @"code": [NSNumber numberWithInteger: errorModel.code]
      });
    }
  } else if ([instance isKindOfClass:[AliMediaDownloader class]]) {
    NSLog(@"");
    _downloaderRejector(@"ERROR_SAVE_FAILED",
                        [NSString stringWithFormat:@"%@:%@", @(errorModel.code), errorModel.message],
                        nil);
    [self destroyDownloader];
  }
}

- (void)save:(NSDictionary *)options
     resolve:(RCTPromiseResolveBlock)resolve
      reject:(RCTPromiseRejectBlock)reject {
  _downloaderResolver = resolve;
  _downloaderRejector = reject;

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

  _downloader = [[AliMediaDownloader alloc] init];
  [_downloader setDelegate:self];
  [_downloader setSaveDirectory: [paths firstObject]];
  [_downloader prepareWithVid:self.stsSource];
}

- (void)destroyDownloader {
  [_downloader destroy];
  _downloader = nil;
}

-(void)onPrepared:(AliMediaDownloader *)downloader mediaInfo:(AVPMediaInfo *)info {
  NSArray<AVPTrackInfo*>* tracks = info.tracks;
  [downloader selectTrack:[tracks objectAtIndex:0].trackIndex];
  [downloader start];
}

-(void)onCompletion:(AliMediaDownloader *)downloader {
  _downloaderResolver(@{@"uri": downloader.downloadedFilePath});
  [self destroyDownloader];
}
@end
