
#import "RNGosellSdkReactNative.h"
#import "RNGosellSdkReactNative-Swift.h"
@implementation RNGosellSdkReactNative

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()
RCT_EXPORT_METHOD(startPayment:(NSDictionary *)arguments callback:(RCTResponseSenderBlock)callback) {
    [SwiftRNGosellSdkReactNative startPayment: arguments callback: callback];
}

@end
  
