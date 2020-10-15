//
//  Bundle+Additions.swift
//  TapVisualEffectView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Bundle {
    
    // MARK: - Internal -
    // MARK: Properties
    
    static let visualEffectViewResourcesBundle: Bundle = {
        
        guard let result = Bundle(for: TapVisualEffectView.self).tap_childBundle(named: Constants.visualEffectViewResourcesBundleName) else {
			
            fatalError("There is no \(Constants.visualEffectViewResourcesBundleName) bundle.")
        }
        
        return result
    }()
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let visualEffectViewResourcesBundleName = "TapVisualEffectViewResources"
    }
}
