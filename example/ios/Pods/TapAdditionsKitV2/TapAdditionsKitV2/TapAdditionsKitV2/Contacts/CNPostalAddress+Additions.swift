//
//  CNPostalAddress+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	Contacts.CNPostalAddress
import var		Contacts.CNPostalAddress.CNPostalAddressStreetKey
import var		Contacts.CNPostalAddress.CNPostalAddressCityKey
import var		Contacts.CNPostalAddress.CNPostalAddressStateKey
import var		Contacts.CNPostalAddress.CNPostalAddressPostalCodeKey
import var		Contacts.CNPostalAddress.CNPostalAddressCountryKey
import var		Contacts.CNPostalAddress.CNPostalAddressISOCountryCodeKey
import var		Contacts.CNPostalAddress.CNPostalAddressSubLocalityKey
import var		Contacts.CNPostalAddress.CNPostalAddressSubAdministrativeAreaKey

/// Useful extension to CNPostalAddress
@available(iOS 9.0, *)
public extension CNPostalAddress {

    // MARK: - Public -
    // MARK: Properties

    /// Returns JSON dictionary representation of the receiver.
    var tap_jsonDictionary: [String: String] {
        
        var result: [String: String] = [:]
        
        if !self.street.isEmpty {

            result[CNPostalAddressStreetKey] = self.street
        }

        if !self.city.isEmpty {
            
            result[CNPostalAddressCityKey] = self.city
        }

        if !self.state.isEmpty {

            result[CNPostalAddressStateKey] = self.state
        }

        if !self.postalCode.isEmpty {
            
            result[CNPostalAddressPostalCodeKey] = self.postalCode
        }
        
        if !self.country.isEmpty {
            
            result[CNPostalAddressCountryKey] = self.country
        }
        
        if !self.isoCountryCode.isEmpty {
            
            result[CNPostalAddressISOCountryCodeKey] = self.isoCountryCode
        }

        if #available(iOS 10.3, *) {

            if !self.subLocality.isEmpty {

                result[CNPostalAddressSubLocalityKey] = self.subLocality
            }

            if !self.subAdministrativeArea.isEmpty {
                
                result[CNPostalAddressSubAdministrativeAreaKey] = self.subAdministrativeArea
            }
        }

        return result
    }
}
