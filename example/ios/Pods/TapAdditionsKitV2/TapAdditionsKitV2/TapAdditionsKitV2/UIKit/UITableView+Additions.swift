//
//  UITableView+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import TapSwiftFixes
import class	UIKit.UITableView.UITableView

/// Useful extension for UITableView
public extension UITableView {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Reloads visible cells.
    ///
    /// - Parameter animation: Row animation.
    func tap_reloadVisibleCells(with animation: UITableView.RowAnimation = .none) {
        
        guard let indexPaths = self.indexPathsForVisibleRows, indexPaths.count > 0 else { return }
        
        let closure = {
            
            self.reloadRows(at: indexPaths, with: animation)
        }
        
        if !catchException(closure, nil) {
            
            self.reloadData()
        }
        
        if animation == .none {
            
            self.tap_removeAllAnimations()
        }
    }
    
    /// Selects row at a given index path, optionally animated, scrolling to selected row and calling delegate.
    ///
    /// - Parameters:
    ///   - indexPath: Index path to select.
    ///   - animated: Defines if selection should happen with animation.
    ///   - scrollPosition: Scroll position.
    ///   - callDelegate: Defines if delegate should be notified about row selection.
    func tap_selectRow(at indexPath: IndexPath, animated: Bool, scrollPosition: UITableView.ScrollPosition, callDelegate: Bool) {
        
        guard (self.isEditing && self.allowsSelectionDuringEditing) || (!self.isEditing && self.allowsSelection) else { return }
        let allowsMultipleSelectionNow = (self.isEditing && self.allowsMultipleSelectionDuringEditing) || (!self.isEditing && self.allowsMultipleSelection)
        
        if let alreadySelectedIndexPath = self.indexPathForSelectedRow, !allowsMultipleSelectionNow {
            
            if alreadySelectedIndexPath == indexPath { return }
            else {
                
                self.deselectRow(at: alreadySelectedIndexPath, animated: animated)
                
                if callDelegate {
                    
                    self.delegate?.tableView?(self, didDeselectRowAt: alreadySelectedIndexPath)
                }
            }
        }
        
        self.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        
        if callDelegate {
            
            self.delegate?.tableView?(self, didSelectRowAt: indexPath)
        }
    }
}
