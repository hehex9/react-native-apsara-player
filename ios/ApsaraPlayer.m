#import "ApsaraPlayer.h"
#import <React/RCTUIManager.h>
#import <React/RCTBridge.h>

@implementation ApsaraPlayer

RCT_EXPORT_MODULE()

- (UIView *)view {
  ApsaraPlayerView *playerView = [ApsaraPlayerView new];
  self.playerView = playerView;
  return playerView;
}

- (dispatch_queue_t)methodQueue{
  return self.bridge.uiManager.methodQueue;
}

RCT_EXPORT_VIEW_PROPERTY(options, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(repeat, BOOL)
RCT_EXPORT_VIEW_PROPERTY(paused, BOOL)
RCT_EXPORT_VIEW_PROPERTY(muted, BOOL)
RCT_EXPORT_VIEW_PROPERTY(volume, float)
RCT_EXPORT_VIEW_PROPERTY(seek, float)
RCT_EXPORT_VIEW_PROPERTY(vid, NSString)

RCT_EXPORT_VIEW_PROPERTY(onVideoLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoSeek, RCTDirectEventBlock)

+ (BOOL)requiresMainQueueSetup {
  return YES;
}
@end
