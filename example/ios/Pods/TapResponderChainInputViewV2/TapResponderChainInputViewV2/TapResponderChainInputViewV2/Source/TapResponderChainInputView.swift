//
//  TapResponderChainInputView.swift
//  TapResponderChainInputView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class	TapNibViewV2.TapNibInputView
import class	UIKit.UIButton.UIButton
import class	UIKit.UIDevice.UIDevice
import protocol	UIKit.UIDevice.UIInputViewAudioFeedback

/// Custom input accessory view with 2 buttons: previous and next.
public class TapResponderChainInputView: TapNibInputView {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Default height.
    public static let defaultHeight: CGFloat = 44.0
    
    /// Global settings.
    public static var globalSettings = TapResponderChainInputViewSettings() {
        
        didSet {
            
            for view in self.aliveInstances {
                
                view.applyChangedSettings(oldValue, new: self.globalSettings)
            }
        }
    }
   
    public override class var bundle: Bundle {

        return .responderChainInputViewResourcesBundle
    }
    
    // MARK: Methods
   
    public override func setup() {
        
        super.setup()
        
        TapResponderChainInputView.aliveInstances.append(self)
        self.applyAllGlobalSettings()
    }
    
    deinit {
        
        if let index = TapResponderChainInputView.aliveInstances.firstIndex(of: self) {
            
            TapResponderChainInputView.aliveInstances.remove(at: index)
        }
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Delegate.
    internal weak var delegate: TapResponderChainInputViewDelegate?
    
    /// Defines if previous button is enabled. Default is true.
    internal var isPreviousButtonEnabled: Bool = true {
        
        didSet {
            
            self.previousButton?.isEnabled = self.isPreviousButtonEnabled
        }
    }
    
    /// Defines if next button is enabled. Default is true.
    internal var isNextButtonEnabled: Bool = true {
        
        didSet {
            
            self.nextButton?.isEnabled = self.isNextButtonEnabled
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var previousButton: UIButton? {
        
        didSet {
            
            self.previousButton?.isEnabled = self.isPreviousButtonEnabled
            self.updatePreviousButtonImages()
        }
    }
    
    @IBOutlet private weak var nextButton: UIButton? {
        
        didSet {
            
            self.nextButton?.isEnabled = self.isNextButtonEnabled
            self.updateNextButtonImages()
        }
    }
    
    private static var aliveInstances: [TapResponderChainInputView] = []
    
    private var shouldApplyRTL: Bool {
        
        guard TapResponderChainInputView.globalSettings.hasRTLLayout else { return false }
        
        if #available(iOS 9.0, *) {
            
            return true
        }
        else {
            
            return false
        }
    }
    
    // MARK: Methods
    
    private func updatePreviousButtonImages() {
        
        guard let nonnullButton = self.previousButton else { return }
        
        let leftToRight = !self.shouldApplyRTL
        let settings = TapResponderChainInputView.globalSettings
        
        nonnullButton.setImage(leftToRight ? settings.previousButtonImageLTR : settings.previousButtonImageRTL, for: .normal)
        nonnullButton.setImage(leftToRight ? settings.previousButtonDisabledImageLTR : settings.previousButtonDisabledImageRTL, for: .disabled)
    }
    
    private func updateNextButtonImages() {
        
        guard let nonnullButton = self.nextButton else { return }
        
        let leftToRight = !self.shouldApplyRTL
        let settings = TapResponderChainInputView.globalSettings
        
        nonnullButton.setImage(leftToRight ? settings.nextButtonImageLTR : settings.nextButtonImageRTL, for: .normal)
        nonnullButton.setImage(leftToRight ? settings.nextButtonDisabledImageLTR : settings.nextButtonDisabledImageRTL, for: .disabled)
    }
    
    @IBAction private func previousButtonTouchUpInside(_ sender: Any) {
        
        UIDevice.current.playInputClick()
        self.delegate?.responderChainInputViewPreviousButtonClicked(self)
    }
    
    @IBAction private func nextButtonTouchUpInside(_ sender: Any) {
        
        UIDevice.current.playInputClick()
        self.delegate?.responderChainInputViewNextButtonClicked(self)
    }
    
    private func applyChangedSettings(_ old: TapResponderChainInputViewSettings, new: TapResponderChainInputViewSettings) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            
            if old.backgroundColor != new.backgroundColor {
                
                strongSelf.backgroundColor = new.backgroundColor
            }
            
            if #available(iOS 9.0, *) {
                
                if old.hasRTLLayout != new.hasRTLLayout {
                    
                    strongSelf.tap_applySemanticContentAttribute(new.hasRTLLayout ? .forceRightToLeft : .forceLeftToRight)
                }
            }
            
            strongSelf.updatePreviousButtonImages()
            strongSelf.updateNextButtonImages()
        }
    }
    
    private func applyAllGlobalSettings() {
        
        let settings = TapResponderChainInputView.globalSettings
        
        self.backgroundColor = settings.backgroundColor
        
        self.updatePreviousButtonImages()
        self.updateNextButtonImages()
        
        if #available(iOS 9.0, *) {
            
            self.tap_applySemanticContentAttribute(settings.hasRTLLayout ? .forceRightToLeft : .forceLeftToRight)
        }
    }
}

// MARK: - UIInputViewAudioFeedback
extension TapResponderChainInputView: UIInputViewAudioFeedback {
    
    public var enableInputClicksWhenVisible: Bool {
        
        return true
    }
}
