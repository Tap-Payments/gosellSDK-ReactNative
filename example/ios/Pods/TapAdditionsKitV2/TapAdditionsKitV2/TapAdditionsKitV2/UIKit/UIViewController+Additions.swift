//
//  UIViewController+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func		ObjectiveC.runtime.objc_getAssociatedObject
import func		ObjectiveC.runtime.objc_setAssociatedObject
import class	UIKit.UIApplication.UIApplication
import enum		UIKit.UIApplication.UIInterfaceOrientation
import struct	UIKit.UIApplication.UIInterfaceOrientationMask
import class	UIKit.UINavigationController.UINavigationController
import class	UIKit.NSLayoutConstraint.NSLayoutConstraint
import class	UIKit.UIResponder.UIResponder
import class	UIKit.UIScreen.UIScreen
import class	UIKit.UIViewController.UIViewController
import class	UIKit.UIWindow.UIWindow
import Foundation
import class UIKit.UIWindowScene
private var tap_separateWindowKey: UInt8 = 0

/// Useful UIViewController extension.
public extension UIViewController {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Defines if receiver is performing any appearance/disappearance transition at the moment.
    var tap_isPerformingTransition: Bool {
        
        return self.isBeingDismissed || self.isBeingPresented || self.tap_isMovingFromParent || self.tap_isMovingToParent
    }
    
    /// Defines if the receiver is moving from parent view controller.
    var tap_isMovingFromParent: Bool {
        
        #if swift(>=4.2)
        
        return self.isMovingFromParent
        
        #else
        
        return self.isMovingFromParentViewController
        
        #endif
    }
    
    /// Defines if the receiver is moving to parent view controller.
    var tap_isMovingToParent: Bool {
        
        #if swift(>=4.2)
        
        return self.isMovingToParent
        
        #else
        
        return self.isMovingToParentViewController
        
        #endif
    }
    
    /// An array of view controllers that are the children of the receiver.
    var tap_children: [UIViewController] {
        
        #if swift(>=4.2)
        
        return self.children
        
        #else
        
        return self.childViewControllers
        
        #endif
    }
    
    /// Returns NSLayoutConstraint which determines height of top layout guide.
    var tap_topLayoutGuideConstraint: NSLayoutConstraint? {
        
        return self.view.constraints.filter { self.topLayoutGuide.isEqual($0.firstItem) && $0.firstAttribute == .height && $0.secondItem == nil }.first
    }
    
    /// Current presented view controller.
    var tap_currentPresentedViewController: UIViewController? {
        
        if let nonnullPresentedViewController = self.presentedViewController, nonnullPresentedViewController.tap_isFullscreen {
            
            return nonnullPresentedViewController.tap_currentPresentedViewController
        }
        else if let nonnullNavigationController = self as? UINavigationController {
            
            return nonnullNavigationController.visibleViewController?.tap_currentPresentedViewController
        }
        else {
            
            return self
        }
    }
    
    /// Displayed view controller.
    var tap_displayedViewController: UIViewController? {
        
        if let presentedController = self.presentedViewController, presentedController.tap_isFullscreen {
            
            return presentedController.tap_displayedViewController
        }
        else if let navController = self as? UINavigationController {
            
            return navController.visibleViewController?.tap_displayedViewController
        }
        else if self.tap_children.count > 0 {
            
            let childControllers = self.tap_children
            for controller in childControllers {
                
                let presentedController = controller.tap_displayedViewController
                if presentedController != controller {
                    
                    return presentedController
                }
            }
            
            return self
        }
        else {
            
            return self
        }
    }
    
    /// Defines if view controller is fullscreen.
    var tap_isFullscreen: Bool {
        
        if let rootControllerBounds = self.tap_foundWindow?.rootViewController?.view.bounds {
            
            return rootControllerBounds.equalTo(view.bounds)
        }
        else {
            
            return false
        }
    }
    
    // MARK: Methods
    
    /// Loads view if it was not loaded.
    func tap_loadViewIfNotLoaded() {
        
        if !self.isViewLoaded {
            
            _ = self.view
        }
    }
    
    /// Finds view controller in hieararchy of all windows.
    ///
    /// - Returns: Found view controller or nil if not found.
    static func tap_findInHierarchy() -> Self? {
        
        return self.tap_findInHierarchy(with: nil)
    }
    
    /// Finds view controller in hieararchy with given root controller.
    ///
    /// - Parameter theRootController: Root view controller. If nil, looks up all hierarchy.
    /// - Returns: Found view controller or nil if not found.
    static func tap_findInHierarchy<T>(with theRootController: UIViewController?) -> T? {
        
        if let nonnullRootController = theRootController {
            
            return self.tap_inHierarchy(with: nonnullRootController)
        }
        else {
            
            for aWindow in UIApplication.shared.windows {
                
                guard let rootViewController = aWindow.rootViewController else { continue }
                
                let found: T? = self.tap_inHierarchy(with: rootViewController)
                if let nonnullFound = found { return nonnullFound }
            }
            
            return nil
        }
    }
    
    /// Finds and returns top controller of navigation controller of a given view controller.
    ///
    /// - Parameter controller: View controller to find parent.
    /// - Returns: View controller.
    static func tap_topControllerInNavigationController(for controller: UIViewController) -> UIViewController {
        
        if let parentController = controller.parent, parentController.navigationController == controller.navigationController {
            
            return self.tap_topControllerInNavigationController(for: parentController)
        }
        else {
            
            return controller
        }
    }
    
    /// Defines if receiver is a child of anotherViewController.
    ///
    /// - Parameter anotherViewController: View controller to test.
    /// - Returns: Boolean
    func tap_isChild(of anotherViewController: UIViewController) -> Bool {
        
        var parentController = self.parent
        while parentController != nil {
            
            if parentController == anotherViewController {
                
                return true
            }
            
            parentController = parentController?.parent
        }
        
        return false
    }
    
    /// Shows view controller from 'nowhere' on a separate window.
    ///
    /// - Parameters:
    ///   - animated: Defines if controller should be presented with animation.
    ///   - windowClass: Window class. Default is UIWindow.
    ///   - windowLevel: Maximal (but now allowed) window level.
    ///   - completion: Completion.
    func tap_showOnSeparateWindow(_ animated: Bool = true, windowClass: UIWindow.Type = UIWindow.self, below windowLevel: UIWindow.Level? = nil, completion: TypeAlias.ArgumentlessClosure?) {
        
        self.tap_showOnSeparateWindow(windowClass: windowClass, below: windowLevel) { (controller) in
            
            controller.present(self, animated: animated, completion: completion)
        }
    }
    
    /// Shows view controller from 'nowhere' giving an option to control the presentation process.
    ///
    /// - Parameters:
    ///   - withUserInteractionEnabled: Defines if user interaction should be enabled in receiver's window.
    ///   - windowClass: Window class. Default is UIWindow
    ///   - windowLevel: Maximal (but now allowed) window level.
    ///   - closure: Closure that has view controller as a parameter.
    ///              This view controller should be the controller that presents the receiver.
    func tap_showOnSeparateWindow(withUserInteractionEnabled: Bool = true, windowClass: UIWindow.Type = UIWindow.self, below windowLevel: UIWindow.Level? = nil, using closure: TypeAlias.GenericViewControllerClosure<SeparateWindowRootViewController>) {
        
        self.tap_prepareSeparateWindow(ofClass: windowClass, withUserInteractionEnabled: withUserInteractionEnabled, below: windowLevel)
        guard let rootController = self.tap_separateWindow?.rootViewController as? SeparateWindowRootViewController else {
            
            fatalError("A problem occured either instantiating separate window or it hasn't got root view controller.")
        }
        
        closure(rootController)
    }
    
    /// Dismisses view controller.
    ///
    /// - Parameters:
    ///   - animated: Defines if controller should be dismissed with an animation.
    ///   - completion: Closure that will be called when the receiver finishes dismissal process.
    func tap_dismissFromSeparateWindow(_ animated: Bool = true, completion: TypeAlias.ArgumentlessClosure?) {
        
        guard self.tap_separateWindow?.rootViewController != nil else {
            
            completion?()
            return
        }
        
        self.tap_dismissFromSeparateWindow { (controller) in
            
            controller.dismiss(animated: animated, completion: completion)
        }
    }
    
    /// Dismisses view controller giving an option to dismiss controller manually but control the animation.
    ///
    /// - Parameter closure: Closure has 2 parameters: viewController - controller that presented the receiver. After the dismissal finished, you should call completion closure in order to clean up everything.
    func tap_dismissFromSeparateWindow(using closure: TypeAlias.UIViewControllerClosure) {
        
        guard let rootController = self.tap_separateWindow?.rootViewController else {
            
            return
        }
        
        closure(rootController)
    }
    
    /// Hides the keyboard if it is shown and calls completion when done.
    ///
    /// - Parameter completion: Completion closure that will be called when keyboard finish hiding.
    func tap_hideKeyboard(_ completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        UIResponder.tap_resign(in: self.view, completion)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var tap_separateWindow: UIWindow? {
        
        get {
            
            return objc_getAssociatedObject(self, &tap_separateWindowKey) as? UIWindow
        }
        set {
            
            objc_setAssociatedObject(self, &tap_separateWindowKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var tap_foundWindow: UIWindow? {
        
        if let nonnullWindow = self.view.window {
            
            return nonnullWindow
        }
        else if let nonnullParentWindow = self.presentingViewController?.view.window {
            
            return nonnullParentWindow
        }
        else {
            
            return nil
        }
    }
    
    // MARK: Methods
    
    private static func tap_inHierarchy<T>(with theRootController: UIViewController) -> T? {
        
        if let rController = theRootController as? T {
            
            return rController
        }
        
        for childController in theRootController.tap_children {
            
            let found: T? = self.tap_inHierarchy(with: childController)
            if let nonnullFound = found { return nonnullFound }
        }
        
        if let presentedController = theRootController.presentedViewController {
            
            let found: T? = self.tap_inHierarchy(with: presentedController)
            if let nonnullFound = found { return nonnullFound }
        }
        
        if let navController = theRootController as? UINavigationController {
            
            for controller in navController.viewControllers {
                
                let found: T? = self.tap_inHierarchy(with: controller)
                if let nonnullFound = found { return nonnullFound }
            }
        }
        
        return nil
    }
    
    private func tap_prepareSeparateWindow<CustomWindow>(ofClass windowClass: CustomWindow.Type, withUserInteractionEnabled: Bool, below windowLevel: UIWindow.Level?) where CustomWindow: UIWindow {
        
        let window = windowClass.init(frame: UIScreen.main.bounds)
        window.rootViewController = SeparateWindowRootViewController.instantiate { [weak self] in self?.tap_removeSeparateWindow() }
        window.tintColor = self.view.tintColor
        window.windowLevel = self.tap_nextSeparateWindowControllerWindowLevel(with: windowLevel)
        
        self.tap_separateWindow = window
        
        if withUserInteractionEnabled {
            if #available(iOS 13.0, *) {
                if let currentWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    window.windowScene = currentWindowScene
                }
            }
            window.makeKeyAndVisible()
        }
        else {
            
            window.isHidden = false
        }
    }
    
    private func tap_nextSeparateWindowControllerWindowLevel(with restrictment: UIWindow.Level?) -> UIWindow.Level {
        
        if let maximalLevel = restrictment {
            
            let possiblyExistingLevel = UIWindow.Level.tap_maximalAmongPresented(lower: maximalLevel)
            
            if UIApplication.shared.windows.first(where: { $0.windowLevel == possiblyExistingLevel }) == nil {
                
                return possiblyExistingLevel
            }
            else if possiblyExistingLevel.tap_rawValue + 1.0 < maximalLevel.tap_rawValue {
                
                return UIWindow.Level(possiblyExistingLevel.tap_rawValue + 1.0)
            }
            else {
                
                let value = possiblyExistingLevel.tap_rawValue + 0.5 * (maximalLevel.tap_rawValue - possiblyExistingLevel.tap_rawValue)
                return UIWindow.Level(value)
            }
        }
        else {
            
            return UIWindow.Level.tap_maximalAmongPresented
        }
    }
    
    private func tap_removeSeparateWindow() {
        guard self.tap_separateWindow != nil else {
            
            self.tap_separateWindow?.isHidden = true
            self.tap_separateWindow?.rootViewController = nil
            self.tap_separateWindow = nil
            return
        }
    }
}

/// This is a class of root view controller in case you want to show view controller on the separate window.
public class SeparateWindowRootViewController: UIViewController {
    
    // MARK: - Public -
    // MARK: Properties
    
    public var allowedInterfaceOrientations: UIInterfaceOrientationMask = .all
    public var preferredInterfaceOrientation: UIInterfaceOrientation?
    public var canAutorotate: Bool = true
    
    public override var shouldAutorotate: Bool {
        
        return self.canAutorotate
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return self.allowedInterfaceOrientations
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        if let nonnullPreferredOrientation = self.preferredInterfaceOrientation {
            
            return nonnullPreferredOrientation
        }
        else {
            
            return UIApplication.shared.statusBarOrientation
        }
    }
    
    // MARK: Methods
    
    public override func dismiss(animated flag: Bool, completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        let localCompletion: TypeAlias.ArgumentlessClosure = {
            
            self.dismissalCompletionClosure?()
            completion?()
        }
        
        guard self.presentedViewController != nil else {
            
            localCompletion()
            return
        }
        
        super.dismiss(animated: flag, completion: localCompletion)
    }
    
    // MARK: - Fileprivate -
    // MARK: Methods
    
    fileprivate static func instantiate(dismissalCompletion: @escaping TypeAlias.ArgumentlessClosure) -> SeparateWindowRootViewController {
        
        let result = SeparateWindowRootViewController()
        result.dismissalCompletionClosure = dismissalCompletion
        
        return result
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var dismissalCompletionClosure: TypeAlias.ArgumentlessClosure?
}
