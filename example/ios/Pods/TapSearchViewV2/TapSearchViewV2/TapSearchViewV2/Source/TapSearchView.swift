//
//  TapSearchView.swift
//  TapSearchView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import func     TapAdditionsKitV2.tap_clamp
import class    TapNibViewV2.TapNibView
import class    UIKit.UIColor.UIColor
import class    UIKit.UIFont.UIFont
import class    UIKit.UIImage.UIImage
import class    UIKit.UIImageView.UIImageView
import class    UIKit.UITextField.UITextField
import class    UIKit.UIView.UIView

/// Tap Search View class, replacement to Apple's `UISearchBar`.
public final class TapSearchView: TapNibView {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// A link to the search field. Use only for customization.
    public var searchField: UITextField {
        
        guard let nonnullField = self.textField else {
            
            fatalError("Search field not loaded.")
        }
        
        return nonnullField
    }
    
    /// Background color of the rounded search holder.
    public var searchHolderBackgroundColor: UIColor? {
        
        get {
            
            return self.searchHolderView?.backgroundColor
        }
        set {
            
            self.searchHolderView?.backgroundColor = newValue
        }
    }
    
    /// Delegate.
    public weak var delegate: TapSearchUpdating?
    
    public override class var bundle: Bundle {
        
        return .tapSearchViewResources
    }
    
    public override var intrinsicContentSize: CGSize {
        
        let screen = self.window?.screen ?? .main
        return CGSize(width: screen.bounds.width, height: Constants.idleHeight)
    }
    
    // MARK: Methods
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        self.updateUIAndInteraction()
    }
    
    public override func setup() {
        
        super.setup()
        self.addTextChangeObserver()
    }
    
    deinit {
        
        self.removeTextChangedObserver()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let idleHeight: CGFloat = 52.0
        fileprivate static let minimalHeight: CGFloat = 16.0
        fileprivate static let searchHolderViewSizeInset: CGFloat = 16.0
        fileprivate static let maximalCornerRadius: CGFloat = 11.0
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var iconImageView: UIImageView? {
        
        didSet {
            
            self.iconImageView?.image = UIImage(named: "ic_search", in: .tapSearchViewResources, compatibleWith: nil)
        }
    }
    
    @IBOutlet private weak var textField: UITextField? {
        
        didSet {
            
            let font = UIFont.systemFont(ofSize: 17.0)
            let color = UIColor(tap_hex: "7B7B83")!
            let attributes: [NSAttributedString.Key: Any] = [
            
                .foregroundColor: color,
                .font: font
            ]
            
            self.textField?.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
        }
    }
    
    @IBOutlet private weak var searchHolderView: UIView?
    
    private var deliveredTextToDelegate: String?
	
	private var textDidChangeNotificationName: Notification.Name {
		
		#if swift(>=4.2)
		
		return UITextField.textDidChangeNotification
		
		#else
		
		return .UITextFieldTextDidChange
		
		#endif
	}
	
    // MARK: Methods
    
    private func updateUIAndInteraction() {
        
        self.updateContentAlpha()
        self.updateSearchHolderCornerRadius()
        self.endEditingIfHeightIsLessThanIdle()
    }
    
    private func updateContentAlpha() {
        
        let heightDifference = Constants.idleHeight - Constants.minimalHeight
        let heightWhenAlpha0 = Constants.minimalHeight + 0.5 * heightDifference
        let heightWhenAlpha1 = Constants.idleHeight
        
        let height = tap_clamp(value: self.bounds.height, low: heightWhenAlpha0, high: Constants.idleHeight)
        let contentAlpha = ( height - heightWhenAlpha0 ) / ( heightWhenAlpha1 - heightWhenAlpha0 )
        self.searchHolderView?.subviews.forEach { $0.alpha = contentAlpha }
    }
    
    private func updateSearchHolderCornerRadius() {
        
        guard let nonnullHolderView = self.searchHolderView else { return }
        
        let desiredCornerRadius = 0.5 * min(nonnullHolderView.bounds.width, self.bounds.height - Constants.searchHolderViewSizeInset)
        let cornerRadius = tap_clamp(value: desiredCornerRadius, low: 0.0, high: Constants.maximalCornerRadius)
        
        nonnullHolderView.tap_cornerRadius = cornerRadius
    }
    
    private func endEditingIfHeightIsLessThanIdle() {
        
        if self.bounds.height < Constants.idleHeight {
            
            self.textField?.endEditing(true)
        }
    }
    
    private func addTextChangeObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextChanged(_:)), name: self.textDidChangeNotificationName, object: nil)
    }
    
    private func removeTextChangedObserver() {
        
        NotificationCenter.default.removeObserver(self, name: self.textDidChangeNotificationName, object: nil)
    }
    
    @objc private func textFieldTextChanged(_ notification: Notification) {
        
        guard let notificationTextField = notification.object as? UITextField else { return }
        
        guard notificationTextField === self.textField else { return }
        
        self.callDelegateIfTextChanged()
    }
    
    private func callDelegateIfTextChanged() {
        
        let text = self.textField?.text ?? .tap_empty
        if self.deliveredTextToDelegate != text {
            
            self.deliveredTextToDelegate = text
            self.delegate?.updateSearchResults(with: text)
        }
    }
}
