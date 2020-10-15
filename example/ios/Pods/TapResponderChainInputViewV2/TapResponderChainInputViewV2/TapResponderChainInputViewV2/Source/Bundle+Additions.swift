//
//  Bundle+Additions.swift
//  TapResponderChainInputView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Bundle {
    
    // MARK: - Internal -
    // MARK: Properties
    
    static let responderChainInputViewResourcesBundle: Bundle = {
        
        guard let result = Bundle(for: TapResponderChainInputView.self).tap_childBundle(named: Constants.resourcesBundleName) else {
            
            fatalError("There is no \(Constants.resourcesBundleName) bundle.")
        }
        
        return result
    }()
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let resourcesBundleName = "TapResponderChainInputViewResources"
        
        @available(*, unavailable) private init() {}
    }
}
