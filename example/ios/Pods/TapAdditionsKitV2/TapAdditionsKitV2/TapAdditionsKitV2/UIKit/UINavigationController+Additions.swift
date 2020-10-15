//
//  UINavigationController+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSDate.TimeInterval
import class	QuartzCore.CATransaction.CATransaction
import func		TapSwiftFixes.performOnMainThread
import class	UIKit.UINavigationController.UINavigationController
import class	UIKit.UIViewController.UIViewController

/// Useful extension to UINavigationController
public extension UINavigationController {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns root view controller of the receiver.
    var tap_rootViewController: UIViewController? {
        
        return self.viewControllers.first
    }
    
    // MARK: Methods
    
    /// Pushes view controller.
    func tap_pushViewController(_ viewController: UIViewController, animated: Bool, completion: TypeAlias.ArgumentlessClosure?) {
        
        if animated {
            
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            
            self.pushViewController(viewController, animated: true)
            
            CATransaction.commit()
        }
        else {
            
            self.pushViewController(viewController, animated: false)
            
            completion?()
        }
    }
    
    /// Pops to root view controller.
    ///
    /// - Parameters:
    ///   - animated: Defines if changes should be animated.
    ///   - completion: Completion closure to be called when animation finishes.
    /// - Returns: Popped view controller.
    @discardableResult func tap_popToRootViewController(animated: Bool, completion: TypeAlias.ArgumentlessClosure?) -> [UIViewController]? {
        
        guard let rootController = self.tap_rootViewController else {
            
            performOnMainThread { completion?() }
            return nil
        }
        
        return self.tap_popToViewController(rootController, animated: animated, completion: completion)
    }
    
    /// Pops to specific view controller.
    @discardableResult func tap_popToViewController(_ viewController: UIViewController, animated: Bool, completion: TypeAlias.ArgumentlessClosure?) -> [UIViewController]? {
        
        let result = popToViewController(viewController, animated: animated)
        type(of: self).tap_callCompletion(completion, afterDelay: animated ? Constants.popAnimationDuration : 0.0)
        
        return result
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let popAnimationDuration: TimeInterval = 0.35
        
        //@available(*, unavailable) private init() {}
    }
    
    // MARK: Methods
    
    private static func tap_callCompletion(_ completion: TypeAlias.ArgumentlessClosure?, afterDelay delay: TimeInterval) {
        
        let deadline = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            
            completion?()
        }
    }
}
