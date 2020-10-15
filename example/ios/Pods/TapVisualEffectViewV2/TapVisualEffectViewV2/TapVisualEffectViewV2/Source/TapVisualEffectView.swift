//
//  TapVisualEffectView.swift
//  TapVisualEffectView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    TapNibViewV2.TapNibView
import struct   UIKit.UIAccessibility.UIAccessibility
import class    UIKit.UIColor.UIColor
import class    UIKit.UIDevice.UIDevice
import class    UIKit.UIView.UIView
import class    UIKit.UIVisualEffectView.UIVisualEffectView

/// This class watches whether reduce transparency feature is enabled and instead of blur uses opacity with alpha.
public final class TapVisualEffectView: TapNibView {

    //MARK: - Public -
    //MARK: Properties
    
    /// Blur style. Animatable.
    public var style: TapBlurEffectStyle = .light {
        
        didSet {
            
            self.visualEffectView.effect = self.style.blurEffect
            self.updateTransparency()
            self.updateMask()
        }
    }
    
    public override var mask: UIView? {
        
        get {
            
            return self.currentMask
        }
        set {
            
            self.applyMask(newValue)
        }
    }
    
    public override class var bundle: Bundle {
        
        return .visualEffectViewResourcesBundle
    }
    
    //MARK: Methods
    
    public override func setup() {

        self.addTransparencyObserver()

        self.updateTransparency()
        self.updateMask()
    }
    
    deinit {
        
        self.removeTransparencyObserver()
    }
    
    //MARK: - Private -
    //MARK: Properties
    
    private var contentView: UIView? {
        
        return self.subviews.first
    }
    
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    
    private var currentMask: UIView?
	
	private var transparencyNotificationName: Notification.Name {
		
		#if swift(>=4.2)
		
		return UIAccessibility.reduceTransparencyStatusDidChangeNotification
		
		#else
		
		return .UIAccessibilityReduceTransparencyStatusDidChange
		
		#endif
	}
    
    //MARK: Methods
    
    private func addTransparencyObserver() {
        
		NotificationCenter.default.addObserver(self, selector: #selector(reduceTransparencyStatusDidChange(_:)), name: self.transparencyNotificationName, object: nil)
    }
    
    private func removeTransparencyObserver() {
        
        NotificationCenter.default.removeObserver(self, name: self.transparencyNotificationName, object: nil)
    }
    
    @objc private func reduceTransparencyStatusDidChange(_ notification: NSNotification) {
        
        DispatchQueue.main.async {
            
            self.updateTransparency()
            self.updateMask()
        }
    }
    
    private func updateTransparency() {
        
        if UIAccessibility.isReduceTransparencyEnabled {
            
            self.visualEffectView.isHidden = true
            self.contentView?.layer.backgroundColor = self.style.tintColor.cgColor
        }
        else {
            
            self.visualEffectView.isHidden = false
            self.contentView?.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    private func applyMask(_ mask: UIView?) {
        
        self.currentMask = mask
        self.updateMask()
    }
    
    private func updateMask() {
        
        let viewToApplyMask = UIAccessibility.isReduceTransparencyEnabled ? self.contentView : self.visualEffectView
        let viewToRemoveMask = UIAccessibility.isReduceTransparencyEnabled ? self.visualEffectView : self.contentView
        
        if UIDevice.current.tap_isRunningIOS9OrLower {
            
            viewToApplyMask?.layer.mask = self.currentMask?.layer
            viewToRemoveMask?.layer.mask = nil
        }
        else {
            
            viewToApplyMask?.mask = self.currentMask
            viewToRemoveMask?.mask = nil
        }
    }
}
