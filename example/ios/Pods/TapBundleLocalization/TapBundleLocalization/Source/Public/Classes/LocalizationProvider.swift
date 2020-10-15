//
//  LocalizationProvider.swift
//  TapBundleLocalization
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum		UIKit.UIInterface.UIUserInterfaceLayoutDirection

/// Localization provider.
public final class LocalizationProvider {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Returns the list of available localizations.
	public var availableLocalizations: [String] {
		
		return self.bundle.localizations
	}
	
	/// Returns suggested interface layout direction based on the selected language.
	public var suggestedInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
		
		return Locale.characterDirection(forLanguage: self.selectedLanguage) == .rightToLeft ? .rightToLeft : .leftToRight
	}
	
	/// Selected locale. Readonly.
	public private(set) lazy var selectedLocale: Locale = Locale(identifier: self.selectedLanguage)
	
	/// Selectr
	public var selectedLanguage: String {
		
		didSet {
			
			guard self.selectedLanguage != oldValue else { return }
			guard self.availableLocalizations.contains(self.selectedLanguage) else {
				
				self.selectedLanguage = oldValue
				return
			}
			
			self.selectedLocale = Locale(identifier: self.selectedLanguage)
			self.selectedLanguageBundle = self.obtainBundleForCurrentLanguage()
		}
	}
	
	// MARK: Methods
	
	/// Initializes localization provider with the contents of a given bundle.
	///
	/// - Parameter bundle: Root bundle where the localizations are stored.
	public init(bundle: Bundle = .main) {
		
		self.bundle = bundle
		
		guard let languageIdentifier = bundle.developmentLocalization ?? bundle.localizations.first else {
			
			fatalError("Bundle \(bundle.bundlePath) does not contain any localizations.")
		}
		
		self.selectedLanguage = languageIdentifier
	}
	
	public func localizedString(for key: LocalizationKey) -> String {
		
		return self.selectedLanguageBundle.localizedString(forKey: key.rawValue, value: nil, table: nil)
	}
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let localeFolderExtension = "lproj"
		
		@available(*, unavailable) private init() {}
	}
	
	// MARK: Properties
	
	private let bundle: Bundle
	
	private lazy var selectedLanguageBundle: Bundle = self.obtainBundleForCurrentLanguage()
	
	// MARK: Methods
	
	private func obtainBundleForCurrentLanguage() -> Bundle {
		
		guard let path = self.bundle.path(forResource: self.selectedLanguage, ofType: Constants.localeFolderExtension) else {
			
			fatalError("Language \(self.selectedLanguage) is missing in \(self.bundle.bundlePath).")
		}
		
		guard let result = Bundle(path: path) else {
			
			fatalError("Failed to load \(self.selectedLanguage) bundle from path \(path).")
		}
		
		return result
	}
}
