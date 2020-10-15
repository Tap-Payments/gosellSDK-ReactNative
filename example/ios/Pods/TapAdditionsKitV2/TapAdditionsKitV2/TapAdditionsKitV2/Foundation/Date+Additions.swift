//
//  Date+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Useful extension to Date.
public extension Date {
    
    // MARK: - Public -
    // MARK: Properties
    
    // Month (1..12) using current calendar.
    var tap_month: Int {
        
        return self.tap_get(.month)
    }
    
    /// Year using current calendar.
    var tap_year: Int {
        
        return self.tap_get(.year)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var tap_currentCalendar: Calendar {
        
        return Calendar(identifier: .gregorian)
    }
    
    // MARK: Methods
    
    private func tap_get(_ component: Calendar.Component) -> Int {
        
        return self.tap_currentCalendar.component(component, from: self)
    }
}
