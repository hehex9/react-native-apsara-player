#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>
#import "ApsaraPlayerView.h"

@interface ApsaraPlayerManager : RCTViewManager <RCTBridgeModule>

@property (nonatomic, strong) ApsaraPlayerView *playerView;

@end
