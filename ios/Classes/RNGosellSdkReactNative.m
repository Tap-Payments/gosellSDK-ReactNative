#if __has_include(<RNGosellSdkReactNative/RNGosellSdkReactNative-Swift.h>)
// For cocoapods framework, the generated swift header will be inside ExpoModulesCore module
#import <RNGosellSdkReactNative/RNGosellSdkReactNative-Swift.h>
#else
#import "RNGosellSdkReactNative-Swift.h"
#endif
#import "RNGosellSdkReactNative.h"
#import <React/RCTLog.h>

@class Bridge;
@implementation RNGosellSdkReactNative {
    Bridge* bridge;
    bool hasListeners;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        bridge = [[Bridge alloc] init];
    }
    return self;
}

// Will be called when this module's first listener is added.
-(void)startObserving {
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"paymentInit"];
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}



RCT_EXPORT_MODULE();
RCT_EXPORT_METHOD(kareem:(RCTResponseSenderBlock)callback){
	callback(@[@"kareem info"]);
}
RCT_EXPORT_METHOD(startPayment:(NSDictionary *)arguments timeout:(int)timeout callback:(RCTResponseSenderBlock)callback){
  [bridge startPayment:arguments timeout:timeout callback:callback paymentInitCallback: ^(NSDictionary* value) {
    if (self->hasListeners) { // Only send events if anyone is listening
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self sendEventWithName:@"paymentInit" body:value];
      });
    }
}];
}
@end
