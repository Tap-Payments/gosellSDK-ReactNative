//
//  TypeAlias.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIImage.UIImage
import class	UIKit.UIViewController.UIViewController

/// Collection of different typealiases.
public struct TypeAlias {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Closure that has no arguments
    public typealias ArgumentlessClosure = () -> Void
    
    /// Closure that accepts Bool and returns void.
    public typealias BooleanClosure = (Bool) -> Void
    
    /// Closure that accepts optional UIImage and returns void.
    public typealias OptionalImageClosure = (UIImage?) -> Void
    
    /// Closure that accepts UIViewController and returns void.
    public typealias UIViewControllerClosure = GenericViewControllerClosure<UIViewController>
    
    /// Closure that accepts any subclass of UIViewController and returns void.
    public typealias GenericViewControllerClosure<ViewControllerType: UIViewController> = (ViewControllerType) -> Void
    
    // MARK: - Private -
    // MARK: Methods
    
    //@available(*, unavailable) private init() {}
}
