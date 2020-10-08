//
//  GoSellSdkReactNativePlugin.m
//  gosellSDKReactNative
//
//  Created by Kareem Ahmed on 9/29/20.
//

#import "React/RCTBridgeModule.h"
@interface RCT_EXTERN_MODULE(GoSellSdkReactNativePlugin, NSObject)
RCT_EXTERN_METHOD(startPayment:(NSDictionary *)arguments callback:(RCTResponseSenderBlock)callback)
@end
