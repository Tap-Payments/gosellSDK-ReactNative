#import "RNGosellSdkReactNative-Swift.h"
#import "RNGosellSdkReactNative.h"
#import <React/RCTLog.h>
//#import <RNGosellSdkReactNative/RNGosellSdkReactNative-Swift.h>
@class Bridge;
@implementation RNGosellSdkReactNative
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(kareem:(RCTResponseSenderBlock)callback){
	callback(@[@"kareem info"]);
}
RCT_EXPORT_METHOD(startPayment:(NSDictionary *)arguments callback:(RCTResponseSenderBlock)callback){
	Bridge* bridge = [[Bridge alloc]init];
	[bridge startPayment:arguments callback:callback];
}

@end
