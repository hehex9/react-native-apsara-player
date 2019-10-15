#import "ApsaraPlayerView.h"

@interface ApsaraPlayerView ()
@property (nonatomic, strong) UIView *playerView;
@end

@implementation ApsaraPlayerView
{
  NSDictionary *_options;
  BOOL _paused;
  NSString *_vid;
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
}

- (void)setPaused:(BOOL)paused {
  if (paused) {
    [_player pause];
  } else {
    [_player start];
  }
  _paused = paused;
}

- (void)setOptions: (NSDictionary *)opts {
  _options = opts;
  [self setupPlayer];
}

- (void)setupPlayer {
  [self addSubview: self.player.playerView];

  NSString *type = [_options objectForKey:@"type"];

  if (_vid == nil || [_vid isEqualToString:@""]) {
    return;
  }

  if ([type isEqualToString:@"vidSts"]) {
    AVPVidStsSource *source = [[AVPVidStsSource alloc] init];
    source.vid = _vid;
    source.region = _options[@"region"];
    source.securityToken = _options[@"securityToken"];
    source.accessKeyId = _options[@"accessKeyId"];
    source.accessKeySecret = _options[@"accessKeySecret"];

    [_player setStsSource:source];
  } else if ([type isEqualToString:@"playAuth"]) {
    AVPVidAuthSource *source = [[AVPVidAuthSource alloc] init];
    source.vid = _vid;
    source.region = @"";
    source.playAuth = _options[@"playAuth"];

    [_player setAuthSource:source];
  }

  [_player prepare];
  if (!_paused) {
    [_player start];
  }
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
    case AVPEventCompletion:
      // 播放完成
      break;
    case AVPEventSeekEnd:
      // 跳转完成
      break;
    case AVPEventLoopingStart:
      // 循环播放开始
      break;
    default:
      break;
  }
}

- (void)onError:(AliPlayer*)player errorModel:(AVPErrorModel *)errorModel {
  [player stop];
}
@end
