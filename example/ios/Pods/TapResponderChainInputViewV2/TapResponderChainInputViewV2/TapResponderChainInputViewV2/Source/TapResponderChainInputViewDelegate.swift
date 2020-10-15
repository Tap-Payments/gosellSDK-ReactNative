//
//  TapResponderChainInputViewDelegate.swift
//  TapResponderChainInputView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

/// Delegate for responder chain input view.
internal protocol TapResponderChainInputViewDelegate: ClassProtocol {
    
    // MARK: Methods
    
    /// Notifies the receiver that previous button was clicked.
    ///
    /// - Parameter responderChainInputView: Sender.
    func responderChainInputViewPreviousButtonClicked(_ responderChainInputView: TapResponderChainInputView)
    
    /// Notifies the receiver that next button was clicked.
    ///
    /// - Parameter responderChainInputView: Sender.
    func responderChainInputViewNextButtonClicked(_ responderChainInputView: TapResponderChainInputView)
}
