//
//  URLSession+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	Dispatch.DispatchSemaphore
import Foundation

/// Useful extension of URLSession.
public extension URLSession {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Static synchronous data task.
    ///
    /// - Parameter request: Request.
    /// - Returns: Tuple: (data, response, error)
    static func tap_synchronousDataTask(with request: URLRequest) -> URLSessionDataTaskResult {
        
        return URLSession.shared.tap_synchronousDataTask(with: request)
    }
    
    /// Synchronous data task.
    ///
    /// - Parameter request: Request.
    /// - Returns: Tuple: (data, response, error)
    func tap_synchronousDataTask(with request: URLRequest) -> URLSessionDataTaskResult {
        
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: request) {
            
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return URLSessionDataTaskResult(data: data, response: response, error: error)
    }
}
