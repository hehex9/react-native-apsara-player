#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import <AliyunPlayer/AliyunPlayer.h>

@interface ApsaraPlayerView : UIView <AVPDelegate>

@property (nonatomic, strong) AliPlayer *player;

@end
