//
//  TapApplication.swift
//  TapApplication
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func     TapSwiftFixes.performOnMainThread
import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.UIApplication.UIApplication
import enum     UIKit.UIApplication.UIInterfaceOrientation
import enum     UIKit.UIApplication.UIStatusBarAnimation
import enum     UIKit.UIApplication.UIStatusBarStyle
import enum     UIKit.UIInterface.UIUserInterfaceLayoutDirection
import class    UIKit.UINavigationBar.UINavigationBar
import class    UIKit.UITabBar.UITabBar
import enum     UIKit.UIView.UISemanticContentAttribute
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController

/// Tap Application interface.
public protocol TapApplication: TapApplicationWithPlist {

    // MARK: Properties

    /// App Store ID.
    var identifier: String { get }

    /// Localized name.
    var localizedName: String { get }

    /// Application layout direction.
    var layoutDirection: UIUserInterfaceLayoutDirection { get }

    /// Required semantic content attribute.
    @available(iOS 9.0, *) var requiredSemanticContentAttribute: UISemanticContentAttribute { get }

    /// Defines if portrait orientation is forced.
    var forcesPortraitOrientation: Bool { get set }

    // MARK: Methods

    /// Forces portrait interface orientation, updates interface orientation ( if required ) and then calls completion.
    ///
    /// - Parameter completion: Completion closure to be called when all updates are finished.
    func forcePortraitOrientationAndRotate(_ completion: TypeAlias.ArgumentlessClosure?)
}

public extension TapApplication {

    // MARK: - Public -
    // MARK: Properties

    /// Application documents path.
    var documentsPath: String {

        return self.directory(with: FileManager.SearchPathDirectory.documentDirectory)
    }

    /// Application cache path.
    var cachesPath: String {

        return self.directory(with: FileManager.SearchPathDirectory.cachesDirectory)
    }

    /// App store URL.
    var appStoreURL: URL {

        let urlString = "https://itunes.apple.com/app/id\(self.identifier)"

        guard let url = URL(string: urlString) else {

            fatalError("\(urlString) is not a valid App Store URL!")
        }

        return url
    }

    /// Application reviews URL. Note: This URL won't be opened on iOS devices with iOS 10.3 or higher. Use 'newApplicationReviewsURL' instead.
    var oldApplicationReviewsURL: URL {

        let reviewsURLString = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8&id=\(self.identifier)"

        guard let url = URL(string: reviewsURLString) else {

            fatalError("\(reviewsURLString) is not a valid App Store Reviews URL!")
        }

        return url
    }

    /// Application reviews URL. Note: This URL won't be opened on iOS devices with iOS 10.3 or less. Use 'oldApplicationReviewsURL' instead.
    var newApplicationReviewsURL: URL {

        let reviewsURLString = "itms-apps://itunes.apple.com/us/app/id\(self.identifier)?action=write-review"

        guard let url = URL(string: reviewsURLString) else {

            fatalError("\(reviewsURLString) is not a valid App Store Reviews URL!")
        }

        return url
    }

    /// Controls status bar visibility.
    ///
    /// - Parameters:
    ///   - hidden: Defines if status bar should be hidden.
    ///   - animation: Animation style.
    func setStatusBarHidden(_ hidden: Bool, with animation: UIStatusBarAnimation) {

        UIApplication.shared.setStatusBarHidden(hidden, with: animation)
    }

    /// Sets application status bar style.
    ///
    /// - Parameters:
    ///   - statusBarStyle: Required status bar style.
    ///   - animated: Defines if change should happen with animation
    func setStatusBarStyle(_ statusBarStyle: UIStatusBarStyle, animated: Bool) {

        UIApplication.shared.setStatusBarStyle(statusBarStyle, animated: animated)
    }

    /// Sets application status bar orientation.
    ///
    /// - Parameters:
    ///   - interfaceOrientation: Required status bar orientation.
    ///   - animated: Defines if change should happen with animation
    func setStatusBarOrientation(_ interfaceOrientation: UIInterfaceOrientation, animated: Bool) {

        UIApplication.shared.setStatusBarOrientation(interfaceOrientation, animated: animated)
    }

    // MARK: Methods

    /// Updates layout direction in the whole app.
    @available(iOS 9.0, *) func updateLayoutDirection() {

        performOnMainThread {

            self.applySemanticContentAttribute(.unspecified)
            self.applySemanticContentAttribute(self.requiredSemanticContentAttribute)
        }
    }

    /// Forces interface orienatation update.
    func forceInterfaceOrientationUpdate(_ completion: TypeAlias.ArgumentlessClosure? = nil) {

        var finishedCount = 0
        let partialCompletion: TypeAlias.ArgumentlessClosure = {

            finishedCount += 1

            if finishedCount == UIApplication.shared.windows.count {

                completion?()
            }
        }

        for window in UIApplication.shared.windows {

            guard let topmostController = window.rootViewController?.tap_currentPresentedViewController else {

                partialCompletion()
                continue
            }

            let tempController = UIViewController()
            tempController.modalPresentationStyle = .overFullScreen

            let dismissControllerClosure: TypeAlias.ArgumentlessClosure = {

                let animations = {

                    DispatchQueue.main.async {

                        topmostController.dismiss(animated: false)
                    }
                }

                UIView.animate(withDuration: UIApplication.shared.statusBarOrientationAnimationDuration, animations: animations) { (_) in

                    partialCompletion()
                }
            }

            DispatchQueue.main.async {

                topmostController.present(tempController, animated: false, completion: dismissControllerClosure)
            }
        }
    }

    // MARK: - Private -
    // MARK: Methods

    private func directory(with searchPath: FileManager.SearchPathDirectory) -> String {

        let mask = FileManager.SearchPathDomainMask.userDomainMask
        return autoreleasepool { return NSSearchPathForDirectoriesInDomains(searchPath, mask, true)[0] }
    }

    @available(iOS 9.0, *) private func applySemanticContentAttribute(_ attribute: UISemanticContentAttribute) {

        UIView.appearance().semanticContentAttribute = attribute
        UINavigationBar.appearance().semanticContentAttribute = attribute
        UITabBar.appearance().semanticContentAttribute = attribute
    }
}
