//
//  UIResponder+Additions.swift
//  TapResponderChainInputView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGPoint
import struct   CoreGraphics.CGGeometry.CGRect
import struct   CoreGraphics.CGGeometry.CGSize
import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UITextField.UITextField

private var tap_previousFieldHandle:        UInt8 = 0
private var tap_nextFieldHandle:            UInt8 = 0

private var tap_manualPreviousButtonHandle: UInt8 = 0
private var tap_manualNextButtonHandle:     UInt8 = 0

public extension UIResponder {
    
    // MARK: - Public -
    
    typealias PreparationsClosure = (@escaping TypeAlias.ArgumentlessClosure) -> Void
    
    // MARK: Properties
    
    /// Previous field in navigation chain.
    @IBOutlet weak var tap_previousField: UIResponder? {
        
        get {
            
            return objc_getAssociatedObject(self, &tap_previousFieldHandle) as? UIResponder
            
        } set {
            
            let changed = (newValue != nil) || ((self.tap_previousField != nil) && (newValue == nil))
            
            objc_setAssociatedObject(self, &tap_previousFieldHandle, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
            if changed {
                
                self.tap_initToolbar()
            }
        }
    }
    
    /// Next field in navigation chain.
    @IBOutlet weak var tap_nextField: UIResponder? {
        
        get {
            
            return objc_getAssociatedObject(self, &tap_nextFieldHandle) as? UIResponder
        }
        set {
            
            let changed = (newValue != nil) || ((self.tap_nextField != nil) && (newValue == nil))
            
            objc_setAssociatedObject(self, &tap_nextFieldHandle, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
            if changed {
                
                self.tap_initToolbar()
            }
        }
    }
    
    var tap_manualToolbarPreviousButtonHandler: TypeAlias.ArgumentlessClosure? {
        
        get {
            
            return objc_getAssociatedObject(self, &tap_manualPreviousButtonHandle) as? TypeAlias.ArgumentlessClosure
        }
        set {
            
            objc_setAssociatedObject(self, &tap_manualPreviousButtonHandle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var tap_manualToolbarNextButtonHandler: TypeAlias.ArgumentlessClosure? {
        
        get {
            
            return objc_getAssociatedObject(self, &tap_manualNextButtonHandle) as? TypeAlias.ArgumentlessClosure
        }
        set {
            
            objc_setAssociatedObject(self, &tap_manualNextButtonHandle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: Methods
    
    func tap_updateToolbarButtonsState() {
        
        guard let toolbar = self.inputAccessoryView as? TapResponderChainInputView else { return }
        
        toolbar.isPreviousButtonEnabled = self.tap_previousField?.canBecomeFirstResponder ?? false
        toolbar.isNextButtonEnabled = self.tap_nextField?.canBecomeFirstResponder ?? false
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func tap_initToolbar() {
        
        guard self.inputAccessoryView == nil && self.responds(to: #selector(setter: UITextField.inputAccessoryView)) else {
            
            self.tap_updateToolbarButtonsState()
            return
        }
        
        let toolbarFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: TapResponderChainInputView.defaultHeight))
        
        let toolbar = TapResponderChainInputView(frame: toolbarFrame)
        
        toolbar.delegate = self
        toolbar.isPreviousButtonEnabled = self.tap_previousField?.canBecomeFirstResponder ?? false
        toolbar.isNextButtonEnabled = self.tap_nextField?.canBecomeFirstResponder ?? false
        
        self.perform(#selector(setter: UITextField.inputAccessoryView), with: toolbar)
    }
}

// MARK: - TapResponderChainInputViewDelegate
extension UIResponder: TapResponderChainInputViewDelegate {
    
    internal func responderChainInputViewPreviousButtonClicked(_ responderChainInputView: TapResponderChainInputView) {
        
        if let nonnullPreviousClickHandler = self.tap_manualToolbarPreviousButtonHandler {
            
            nonnullPreviousClickHandler()
        }
        else {
            
            self.tap_previousField?.becomeFirstResponder()
        }
    }
    
    internal func responderChainInputViewNextButtonClicked(_ responderChainInputView: TapResponderChainInputView) {
        
        if let nonnullNextClickHandler = self.tap_manualToolbarNextButtonHandler {
            
            nonnullNextClickHandler()
        }
        else {
            
            self.tap_nextField?.becomeFirstResponder()
        }
    }
}
