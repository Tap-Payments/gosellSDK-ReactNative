//
//  UICollectionView+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import class	UIKit.UICollectionView.UICollectionView

/// Useful additions for UICollectionView.
public extension UICollectionView {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns selected index path if collection view is in a single selection mode.
    var tap_indexPathForSelectedItem: IndexPath? {
        
        guard !self.allowsMultipleSelection else { return nil }
        
        return self.indexPathsForSelectedItems?.first
    }
}
