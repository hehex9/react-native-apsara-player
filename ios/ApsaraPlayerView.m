#import "ApsaraPlayerView.h"

@interface ApsaraPlayerView ()
@property (nonatomic, strong) UIView *playerView;
@end

@implementation ApsaraPlayerView
{
  NSDictionary *_src;
  BOOL _paused;
  BOOL _prepared;
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

- (AVPVidStsSource *) stsSource:(NSDictionary *)opts {
  AVPVidStsSource *source = [[AVPVidStsSource alloc] init];
  source.vid = opts[@"vid"];
  source.region = opts[@"region"];
  source.securityToken = opts[@"securityToken"];
  source.accessKeyId = opts[@"accessKeyId"];
  source.accessKeySecret = opts[@"accessKeySecret"];
  return source;
}

- (AVPVidAuthSource *) authSource:(NSDictionary *)opts {
  AVPVidAuthSource *source = [[AVPVidAuthSource alloc] init];
  source.vid = opts[@"vid"];
  source.region = opts[@"region"];
  source.playAuth = opts[@"playAuth"];
  return source;
}

- (void)setSource: (NSDictionary *)source {
  _src = source;

  [self addSubview: self.player.playerView];

  if (_src[@"uri"] && ![(NSString *)_src[@"uri"] isEqualToString:@""]) {
    [_player setUrlSource:[[AVPUrlSource alloc] urlWithString:_src[@"uri"]]];
  } else if (_src[@"sts"] && _src[@"sts"][@"vid"]) {
    [_player setStsSource: [self stsSource:_src[@"sts"]]];
  } else if (_src[@"auth"] && _src[@"auth"][@"vid"]) {
    [_player setAuthSource: [self authSource:_src[@"auth"]]];
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

  NSDictionary *opts = options ? options : _src;
  if (opts[@"sts"] && opts[@"sts"][@"vid"]) {
    [_downloader prepareWithVid:[self stsSource:opts[@"sts"]]];
  } else if (opts[@"auth"] && opts[@"auth"][@"vid"]) {
    [_downloader prepareWithPlayAuth:[self authSource:opts[@"auth"]]];
  } else {
    reject(@"ERROR_SAVE_FAILED", @"invalid source", nil);
  }
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
