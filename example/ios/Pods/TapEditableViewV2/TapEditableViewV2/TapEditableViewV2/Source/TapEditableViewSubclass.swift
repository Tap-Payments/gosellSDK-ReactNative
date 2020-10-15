//
//  TapEditableViewSubclass.swift
//  TapEditableView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGGeometry.CGRect

/// Base point to override TapEditableView.
open class TapEditableViewSubclass: TapEditableView {

    // MARK: - Open -
    // MARK: Methods

    /// Point of customization. Setup everything here. Default implementation does nothing.
    open func setup() { }

    // MARK: - Public -
    // MARK: Methods

    public override init(frame aFrame: CGRect) {

        super.init(frame: aFrame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        self.setup()
    }
}
