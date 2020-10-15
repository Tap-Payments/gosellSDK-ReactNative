//
//  CNSocialProfile+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	Contacts.CNSocialProfile
import var		Contacts.CNSocialProfile.CNSocialProfileURLStringKey
import var		Contacts.CNSocialProfile.CNSocialProfileUsernameKey
import var		Contacts.CNSocialProfile.CNSocialProfileUserIdentifierKey
import var		Contacts.CNSocialProfile.CNSocialProfileServiceKey

/// Useful addition to CNSocialProfile.
@available(iOS 9.0, *)
public extension CNSocialProfile {

    // MARK: - Public -
    // MARK: Properties

    /// Returns JSON dictionary representation of the receiver.
    var tap_jsonDictionary: [String: String] {

        var result: [String: String] = [:]

        if !self.urlString.isEmpty {

            result[CNSocialProfileURLStringKey] = self.urlString
        }

        if !self.username.isEmpty {

            result[CNSocialProfileUsernameKey] = self.username
        }

        if !self.userIdentifier.isEmpty {

            result[CNSocialProfileUserIdentifierKey] = self.userIdentifier
        }

        if !self.service.isEmpty {

            result[CNSocialProfileServiceKey] = self.service
        }

        return result
    }
}
