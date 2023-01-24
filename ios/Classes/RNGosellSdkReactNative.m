#import "RNGosellSdkReactNative-Swift.h"
#import "RNGosellSdkReactNative.h"
#import <React/RCTLog.h>
//#import <RNGosellSdkReactNative/RNGosellSdkReactNative-Swift.h>
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
  [bridge startPayment:arguments timeout:timeout callback:callback paymentInitCallback: ^(NSString * value) {
    if (self->hasListeners) { // Only send events if anyone is listening
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self sendEventWithName:@"paymentInit" body: @{@"chargeId": value}];
      });
    }
}];
}
@end
