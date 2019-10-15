#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>
#import "ApsaraPlayerView.h"

@interface ApsaraPlayer : RCTViewManager <RCTBridgeModule>

@property (nonatomic, strong) ApsaraPlayerView *playerView;

@end
