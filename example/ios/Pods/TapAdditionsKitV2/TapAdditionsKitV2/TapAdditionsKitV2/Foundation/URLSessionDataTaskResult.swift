//
//  URLSessionDataTaskResult.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation

/// Structure representing result of URLSessionDataTask
public struct URLSessionDataTaskResult {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Response data.
    public let data: Data?
    
    /// URL response.
    public let response: URLResponse?
    
    /// Error ( if occured ).
    public let error: Error?
    
    /// Initializes result with data, response and error.
    ///
    /// - Parameters:
    ///   - data: Response data.
    ///   - response: URL response.
    ///   - error: Error ( if occured ).
    public init(data: Data?, response: URLResponse?, error: Error?) {
        
        self.data = data
        self.response = response
        self.error = error
    }
}
