//
//  TapEditableView.swift
//  TapEditableView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UITapGestureRecognizer.UITapGestureRecognizer
import class UIKit.UIView.UIView

open class TapEditableView: UIView {

    // MARK: - Open -
    // MARK: Properties

    /// Delegate.
    open weak var delegate: TapEditableViewDelegate?

    /// Defines if receiver is editing at the moment.
    open var isEditing: Bool {

        return self.isFirstResponder
    }

    open override var canBecomeFirstResponder: Bool {

        return self.isUserInteractionEnabled
    }

    open override var canResignFirstResponder: Bool {

        return true
    }

    open override var inputView: UIView? {

        get {

            return self.storedInputView
        }
        set {

            self.storedInputView = newValue

            if self.isFirstResponder {

                self.reloadInputViews()
            }
        }
    }

    open override var inputAccessoryView: UIView? {

        get {

            return self.storedInputAccessoryView
        }
        set {

            self.storedInputAccessoryView = newValue

            if self.isFirstResponder {

                self.reloadInputViews()
            }
        }
    }

    // MARK: Methods

    @discardableResult open override func becomeFirstResponder() -> Bool {

        let result = super.becomeFirstResponder()

        if result {

            self.delegate?.editableViewDidBeginEditing(self)
        }

        return result
    }

    @discardableResult open override func resignFirstResponder() -> Bool {

        let result = super.resignFirstResponder()

        if result {

            self.delegate?.editableViewDidEndEditing(self)
        }

        return result
    }

    open override func willMove(toSuperview newSuperview: UIView?) {

        super.willMove(toSuperview: newSuperview)

        if newSuperview == nil {

            self.removeTapRecognizer()

        } else {

            self.addTapRecognizer()
        }
    }

    // MARK: - Private -
    // MARK: Properties

    private var tapRecognizer: UITapGestureRecognizer?

    private var storedInputView: UIView?
    private var storedInputAccessoryView: UIView?

    // MARK: Methods

    private func addTapRecognizer() {

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(with:)))
        self.addGestureRecognizer(recognizer)

        self.tapRecognizer = recognizer
    }

    private func removeTapRecognizer() {

        guard let recognizer = self.tapRecognizer else { return }

        self.removeGestureRecognizer(recognizer)
        self.tapRecognizer = nil
    }

    @objc private func tapDetected(with recognizer: UITapGestureRecognizer) {

        if recognizer.state == .ended {

            self.becomeFirstResponder()
        }
    }
}
