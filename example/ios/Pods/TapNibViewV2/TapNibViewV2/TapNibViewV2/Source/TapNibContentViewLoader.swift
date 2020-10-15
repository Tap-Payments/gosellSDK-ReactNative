//
//  TapNibContentViewLoader.swift
//  TapNibView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol
import class    UIKit.UINib.UINib
import class    UIKit.UIView.UIView

/// Content view loading helper protocol.
internal protocol TapNibContentViewLoader: ClassProtocol, TapNibLoading {

    var isContentViewLoaded: Bool { get set }
}

internal extension TapNibContentViewLoader {

    // MARK: - Internal -
    // MARK: Methods

    func loadContentView() {

        guard !self.isContentViewLoaded else { return }
        let selfType = type(of: self)
        let nib = UINib(nibName: selfType.nibName, bundle: selfType.bundle)

        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {

            fatalError("Failed to instantiate \(selfType.tap_className) from nib named \(selfType.nibName).")
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        self.tap_addSubviewWithConstraints(contentView, respectLanguageDirection: true)
        contentView.tap_setTranslatesAutoresizingMasksIntoConstrants(false, includeSubviews: true)

        self.isContentViewLoaded = true

        self.setup()
    }
}
