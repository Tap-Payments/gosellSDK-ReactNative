//
//  Bundle+Additions.swift
//  TapSearchView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Bundle {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Tap Search View Resources bundle.
    static let tapSearchViewResources: Bundle = {
        
        guard let result = Bundle(for: TapSearchView.self).tap_childBundle(named: Constants.tapSearchViewResourcesBundleName) else {
            
            fatalError("There is no \(Constants.tapSearchViewResourcesBundleName) bundle.")
        }
        
        return result
    }()
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let tapSearchViewResourcesBundleName = "TapSearchViewResources"
        
        @available(*, unavailable) private init() {}
    }
}
