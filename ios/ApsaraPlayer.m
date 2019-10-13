#import "ApsaraPlayer.h"

@implementation ApsaraPlayer

RCT_EXPORT_MODULE()

- (UIView *)view {
    // TODO: Implement some actually useful functionality
    UILabel * label = [[UILabel alloc] init];
    [label setTextColor:[UIColor greenColor]];
    [label setText: @"*****"];
    [label sizeToFit];
    UIView * wrapper = [[UIView alloc] init];
    [wrapper addSubview:label];
    return wrapper;
}

@end
