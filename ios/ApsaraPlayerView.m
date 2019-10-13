#import "ApsaraPlayerView.h"

@interface ApsaraPlayerView ()

@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *playerView;

@end

@implementation ApsaraPlayerView

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

- (void) setOptions:(NSDictionary *) opts {
  _options = opts;
  [self setupPlayer];
}

- (void) setMuteMode:(BOOL) muteMode {
  self.player.muteMode = muteMode;
}

- (void) setQuality:(NSInteger)quality {
  self.player.quality = quality;
}

- (void)setVolume:(float)volume {
  self.player.volume = volume;
}

- (void)setBrightness:(float)brightness {
  self.player.brightness = brightness;
}

- (void)setupPlayer {
  [self addSubview: self.player.playerView];

  NSString *type = [_options objectForKey:@"type"];

  if ([type isEqualToString:@"vidSts"]) {
    NSString *vid = _options[@"vid"];
    NSString *accessKeyId = _options[@"accessKeyId"];
    NSString *accessKeySecret = _options[@"accessKeySecret"];
    NSString *securityToken = _options[@"securityToken"];

  } else if ([type isEqualToString:@"playAuth"]) {

  }

  [self.player prepare];
}


- (AliPlayer *) player{
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

- (UIView *) playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
    }
    return _playerView;
}

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

@end
