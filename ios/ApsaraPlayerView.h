#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import <React/RCTBridgeModule.h>
#import <AliyunPlayer/AliyunPlayer.h>

@interface ApsaraPlayerView : UIView <AVPDelegate>

@property (nonatomic, strong) AliPlayer *player;
@property (nonatomic, copy) RCTDirectEventBlock onVideoSeek;
@property (nonatomic, copy) RCTDirectEventBlock onVideoLoad;

@end
