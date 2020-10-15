//
//  TapNibLoading.swift
//  TapNibView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIView.UIView

/// Tap Nib Loading Protocol
public protocol TapNibLoading where Self: UIView {

    // MARK: Properties

    /// Defines if content view is loaded.
    var isContentViewLoaded: Bool { get }

    /// Nib name. Override this property only if nib name is diferent from the class name.
    static var nibName: String { get }

    /// Bundle where the nib is stored. Override this property only if nib's bundle is different from class bundle.
    static var bundle: Bundle { get }

    // MARK: Methods

    /// Point to override. At the moment when this method is called, all view hierarchy is loaded.
    /// Default implementation does nothing.
    func setup()
}
