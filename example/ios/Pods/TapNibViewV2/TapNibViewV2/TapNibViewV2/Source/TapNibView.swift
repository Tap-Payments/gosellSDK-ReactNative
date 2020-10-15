//
//  TapNibView.swift
//  TapNibView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGRect
import struct   CoreGraphics.CGGeometry.CGSize
import class    Foundation.NSBundle.Bundle
import class    Foundation.NSCoder.NSCoder
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UIView.UIView

/// Base class for all the views that support loading from a nib file.
open class TapNibView: UIView, TapNibLoading {

    // MARK: - Open -
    // MARK: Properties

    open class var nibName: String {

        return self.tap_className
    }

    open class var bundle: Bundle {

        return Bundle(for: self)
    }

    // MARK: Methods

    open func setup() {}

    // MARK: - Public -
    // MARK: Properties

    public lazy var isContentViewLoaded: Bool = false

    // MARK: Methods

    public override init(frame: CGRect) {

        super.init(frame: frame)
        self.loadContentView()
    }

    public required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        self.loadContentView()
    }

    public convenience init() {

        self.init(frame: NibViewConstants.defaultFrame)
    }

    // MARK: - Private -

    private struct NibViewConstants {

        fileprivate static let defaultFrame = CGRect(origin: .zero,
                                                     size: CGSize(width: UIScreen.main.bounds.width, height: 64.0))
    }
}

// MARK: - TapNibContentViewLoader
extension TapNibView: TapNibContentViewLoader {}
