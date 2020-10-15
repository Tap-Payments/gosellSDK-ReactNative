//
//  CNContactFetchRequest+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	Contacts.CNContactFetchRequest
import var		Contacts.CNContactNamePrefixKey
import var		Contacts.CNContactGivenNameKey
import var		Contacts.CNContactMiddleNameKey
import var		Contacts.CNContactFamilyNameKey
import var		Contacts.CNContactPreviousFamilyNameKey
import var		Contacts.CNContactNameSuffixKey
import var		Contacts.CNContactNicknameKey
import var		Contacts.CNContactOrganizationNameKey
import var		Contacts.CNContactDepartmentNameKey
import var		Contacts.CNContactJobTitleKey
import var		Contacts.CNContactPhoneticGivenNameKey
import var		Contacts.CNContactPhoneticMiddleNameKey
import var		Contacts.CNContactPhoneticFamilyNameKey
import var		Contacts.CNContactBirthdayKey
import var		Contacts.CNContactNonGregorianBirthdayKey
import var		Contacts.CNContactNoteKey
import var		Contacts.CNContactImageDataKey
import var		Contacts.CNContactThumbnailImageDataKey
import var		Contacts.CNContactImageDataAvailableKey
import var		Contacts.CNContactTypeKey
import var		Contacts.CNContactPhoneNumbersKey
import var		Contacts.CNContactEmailAddressesKey
import var		Contacts.CNContactPostalAddressesKey
import var		Contacts.CNContactDatesKey
import var		Contacts.CNContactUrlAddressesKey
import var		Contacts.CNContactRelationsKey
import var		Contacts.CNContactSocialProfilesKey
import var		Contacts.CNContactInstantMessageAddressesKey
import var		Contacts.CNContactPhoneticOrganizationNameKey
import protocol	Contacts.CNKeyDescriptor

/// Useful additions to CNContactFetchRequest.
@available(iOS 9.0, *)
public extension CNContactFetchRequest {

    // MARK: - Public -
    // MARK: Properties

    /// Returns all possible fetch keys.
    static let tap_allFetchKeys: [CNKeyDescriptor] = {

        var keys: [String] = [

            CNContactNamePrefixKey,
            CNContactGivenNameKey,
            CNContactMiddleNameKey,
            CNContactFamilyNameKey,
            CNContactPreviousFamilyNameKey,
            CNContactNameSuffixKey,
            CNContactNicknameKey,
            CNContactOrganizationNameKey,
            CNContactDepartmentNameKey,
            CNContactJobTitleKey,
            CNContactPhoneticGivenNameKey,
            CNContactPhoneticMiddleNameKey,
            CNContactPhoneticFamilyNameKey,
            CNContactBirthdayKey,
            CNContactNonGregorianBirthdayKey,
            CNContactNoteKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey,
            CNContactImageDataAvailableKey,
            CNContactTypeKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactPostalAddressesKey,
            CNContactDatesKey,
            CNContactUrlAddressesKey,
            CNContactRelationsKey,
            CNContactSocialProfilesKey,
            CNContactInstantMessageAddressesKey
        ]

        if #available(iOS 10.0, *) {

            keys += CNContactPhoneticOrganizationNameKey
        }

        return keys as [CNKeyDescriptor]
    }()

    /// Returns fetch request to fetch all contacts with all keys.
    static let tap_fetchingEverything: CNContactFetchRequest = {

        return CNContactFetchRequest(keysToFetch: CNContactFetchRequest.tap_allFetchKeys)
    }()
}
