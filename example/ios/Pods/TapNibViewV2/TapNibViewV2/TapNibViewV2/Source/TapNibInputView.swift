//
//  TapNibInputView.swift
//  TapNibView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGRect
import struct   CoreGraphics.CGGeometry.CGSize
import class    Foundation.NSBundle.Bundle
import class    Foundation.NSCoder.NSCoder
import class    UIKit.UIInputView.UIInputView
import class    UIKit.UIScreen.UIScreen

/// Same as Tap Nib View, but inherited from UIInputView
open class TapNibInputView: UIInputView, TapNibLoading {

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

    public override init(frame: CGRect, inputViewStyle: UIInputView.Style) {

        super.init(frame: frame, inputViewStyle: inputViewStyle)
        self.loadContentView()
    }

    public required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        self.loadContentView()
    }

    public convenience init() {

        self.init(frame: NibInputViewConstants.defaultFrame)
    }

    // MARK: - Private -

    private struct NibInputViewConstants {

        fileprivate static let defaultFrame = CGRect(origin: .zero,
                                                     size: CGSize(width: UIScreen.main.bounds.width, height: 64.0))
    }
}

// MARK: - TapNibContentViewLoader
extension TapNibInputView: TapNibContentViewLoader {}
