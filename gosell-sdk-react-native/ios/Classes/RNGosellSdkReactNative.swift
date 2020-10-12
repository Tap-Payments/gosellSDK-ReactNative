import Foundation

@objc(RNGosellSdkReactNative)
public class RNGosellSdkReactNative: NSObject {
	var reactResult: RCTResponseSenderBlock?


  @objc public func startPayment(_ arguments: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
	print("arguments: \(arguments)")

	reactResult = callback
  }

}
