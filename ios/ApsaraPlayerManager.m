#import <React/RCTUIManager.h>
#import <React/RCTBridge.h>
#import "ApsaraPlayerManager.h"

@implementation ApsaraPlayerManager

RCT_EXPORT_MODULE()

- (UIView *)view {
  ApsaraPlayerView *playerView = [ApsaraPlayerView new];
  self.playerView = playerView;
  return playerView;
}

- (dispatch_queue_t)methodQueue{
  return self.bridge.uiManager.methodQueue;
}

RCT_EXPORT_VIEW_PROPERTY(repeat, BOOL)
RCT_EXPORT_VIEW_PROPERTY(paused, BOOL)
RCT_EXPORT_VIEW_PROPERTY(muted, BOOL)
RCT_EXPORT_VIEW_PROPERTY(volume, float)
RCT_EXPORT_VIEW_PROPERTY(seek, float)
RCT_EXPORT_VIEW_PROPERTY(source, NSDictionary)

RCT_EXPORT_VIEW_PROPERTY(onVideoLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoSeek, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoEnd, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoProgress, RCTDirectEventBlock)

RCT_REMAP_METHOD(save,
    options:(NSDictionary *)options
    reactTag:(nonnull NSNumber *)reactTag
    resolver:(RCTPromiseResolveBlock)resolve
    rejecter:(RCTPromiseRejectBlock)reject) {
  [self.bridge.uiManager prependUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, ApsaraPlayerView *> *viewRegistry) {
    ApsaraPlayerView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[ApsaraPlayerView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting ApsaraPlayerView, got: %@", view);
    } else {
      [view save:options resolve:resolve reject:reject];
    }
  }];
}

RCT_REMAP_METHOD(destroy, reactTag:(nonnull NSNumber *)reactTag) {
  [self.bridge.uiManager prependUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, ApsaraPlayerView *> *viewRegistry) {
    ApsaraPlayerView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[ApsaraPlayerView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting ApsaraPlayerView, got: %@", view);
    } else {
      [view destroy];
    }
  }];
}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}
@end
