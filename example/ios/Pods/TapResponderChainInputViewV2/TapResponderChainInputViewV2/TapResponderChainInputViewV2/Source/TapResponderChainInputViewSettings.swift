//
//  TapResponderChainInputViewSettings.swift
//  TapResponderChainInputView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIColor.UIColor
import class UIKit.UIImage.UIImage

/// Responder chain input view settings.
public struct TapResponderChainInputViewSettings {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// If property is set to true, RTL layout direction will be used. Default is false.
    /// Note: This property has no effect on iOS 8.
    public var hasRTLLayout = false
    
    /// Background color.
    public var backgroundColor: UIColor = .clear
    
    /// Image for previous button in LTR
    public var previousButtonImageLTR: UIImage = Constants.arrowLeftImage
    
    /// Image for previous button in RTL
    public var previousButtonImageRTL: UIImage = Constants.arrowRightImage
    
    /// Image for disabled state of previous button in LTR
    public var previousButtonDisabledImageLTR: UIImage = Constants.arrowLeftDisabledImage
    
    /// Image for disabled state of previous button in RTL
    public var previousButtonDisabledImageRTL: UIImage = Constants.arrowRightDisabledImage
    
     /// Image for next button in LTR
    public var nextButtonImageLTR: UIImage = Constants.arrowRightImage
    
     /// Image for next button in RTL
    public var nextButtonImageRTL: UIImage = Constants.arrowLeftImage
    
    /// Image for disabled state of next button in LTR
    public var nextButtonDisabledImageLTR: UIImage = Constants.arrowRightDisabledImage
    
    /// Image for disabled state of next button in RTL
    public var nextButtonDisabledImageRTL: UIImage = Constants.arrowLeftDisabledImage
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init() {}
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let arrowLeftDisabledImage: UIImage = {
           
            guard let result = UIImage(named: Constants.arrowLeftDisabledImageName, in: .responderChainInputViewResourcesBundle, compatibleWith: nil) else {
                
                fatalError("Failed to load image named \"\(Constants.arrowLeftDisabledImageName)\" from tap responder chain input view resources bundle.")
            }
            
            return result
        }()
        
        fileprivate static let arrowRightDisabledImage: UIImage = {
            
            guard let result = UIImage(named: Constants.arrowRightDisabledImageName, in: .responderChainInputViewResourcesBundle, compatibleWith: nil) else {
                
                fatalError("Failed to load image named \"\(Constants.arrowRightDisabledImageName)\" from tap responder chain input view resources bundle.")
            }
            
            return result
        }()
        
        fileprivate static let arrowLeftImage: UIImage = {
            
            guard let result = UIImage(named: Constants.arrowLeftImageName, in: .responderChainInputViewResourcesBundle, compatibleWith: nil) else {
                
                fatalError("Failed to load image named \"\(Constants.arrowLeftImageName)\" from tap responder chain input view resources bundle.")
            }
            
            return result
        }()
        
        fileprivate static let arrowRightImage: UIImage = {
            
            guard let result = UIImage(named: Constants.arrowRightImageName, in: .responderChainInputViewResourcesBundle, compatibleWith: nil) else {
                
                fatalError("Failed to load image named \"\(Constants.arrowRightImageName)\" from tap responder chain input view resources bundle.")
            }
            
            return result
        }()
        
        private static let arrowLeftDisabledImageName = "ic_arrow_left_disabled"
        private static let arrowRightDisabledImageName = "ic_arrow_right_disabled"
        private static let arrowLeftImageName = "ic_arrow_left"
        private static let arrowRightImageName = "ic_arrow_right"
        
        @available(*, unavailable) private init() {}
    }
}
