
#import "RNGosellSdkReactNative.h"

@implementation RNGosellSdkReactNative

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()
RCT_EXTERN_METHOD(startPayment:(NSDictionary *)arguments callback:(RCTResponseSenderBlock)callback)

@end
  