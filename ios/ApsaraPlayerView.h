#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import <React/RCTBridgeModule.h>
#import <AliyunPlayer/AliyunPlayer.h>
#import <AliyunMediaDownloader/AliyunMediaDownloader.h>

@interface ApsaraPlayerView : UIView <AVPDelegate, AMDDelegate>

@property (nonatomic, strong) AliPlayer *player;
@property (nonatomic, copy) RCTDirectEventBlock onVideoLoad;
@property (nonatomic, copy) RCTDirectEventBlock onVideoSeek;
@property (nonatomic, copy) RCTDirectEventBlock onVideoEnd;
@property (nonatomic, copy) RCTDirectEventBlock onVideoError;
@property (nonatomic, copy) RCTDirectEventBlock onVideoProgress;

- (void)save:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject;
- (void)destroy;

@end
