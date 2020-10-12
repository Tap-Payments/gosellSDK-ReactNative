//
//  SwiftRNGosellSdkReactNative.swift
//  SwiftRNGosellSdkReactNative
//
//  Created by Kareem Ahmed on 10/12/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc(SwiftRNGosellSdkReactNative)
public class SwiftRNGosellSdkReactNative: NSObject {
//  let session = Session()
  public var argsSessionParameters:[String:Any]?
  public var argsAppCredentials:[String:String]?
  var reactResult: RCTResponseSenderBlock?
  var argsDataSource:[String:Any]?{
    didSet{
      argsSessionParameters = argsDataSource?["sessionParameters"] as? [String : Any]
      argsAppCredentials = argsDataSource?["appCredentials"] as? [String : String]
    }
  }
  
  @objc public func startPayment(_ arguments: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
    argsDataSource = arguments as? [String: Any]
    print("arguments: \(arguments)")
  }
}
