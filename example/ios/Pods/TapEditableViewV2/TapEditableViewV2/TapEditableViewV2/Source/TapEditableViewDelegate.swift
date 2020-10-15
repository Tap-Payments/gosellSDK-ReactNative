//
//  TapEditableViewDelegate.swift
//  TapEditableView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

public protocol TapEditableViewDelegate: ClassProtocol {

    func editableViewDidBeginEditing(_ editableView: TapEditableView)
    func editableViewDidEndEditing(_ editableView: TapEditableView)
}
