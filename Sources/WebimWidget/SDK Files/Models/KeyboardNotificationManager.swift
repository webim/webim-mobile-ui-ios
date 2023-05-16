//
//  KeyboardNotificationManager.swift
//  WebimClientLibrary_Example
//
//  Created by Аслан Кутумбаев on 10.01.2023.
//  Copyright © 2023 Webim. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

enum HeightChangeKind {
    case unknown
    case quote
    case newMessage
}

struct KeyboardViewModel {
    var parentViewSafeArea: CGFloat
    var toolbarViewHeight: CGFloat
    var scrollViewContentOffset: CGFloat
    var scrollViewContentInset: CGFloat
    var scrollIndicatorContentInset: CGFloat
    var isTracking: Bool
}

protocol HeightChangedHandlerProtcol: AnyObject {
    func heightChanged(from oldHeight: CGFloat, to newHeight: CGFloat, kind: HeightChangeKind)
}

protocol HeightChangable: AnyObject {
    var heightChangedHandler: HeightChangedHandlerProtcol? { get set }
}

protocol KeyboardNotificationManagerDelegate: AnyObject {
    func updateScrollButtonConstraints(_ keyboardHeight: CGFloat)
    func setScrollIndicatorInset(_ inset: CGFloat)
    func setScrollViewInset(_ inset: CGFloat)
    func setScrollViewOffset(_ offset: CGFloat)
    func layoutIfNeeded()
}

class KeyboardNotificationManager {

    weak var delegate: KeyboardNotificationManagerDelegate?

    private var toolbarHeightRelativeDelta: CGFloat {
        return newMessageHeightRelativeDelta + quoteHeightRelativeDelta
    }

    private var toolbarHeightAbsoluteDelta: CGFloat {
        return newMessageHeightAbsoluteDelta + quoteHeightAbsoluteDelta
    }

    private var quoteHeightChanged = false
    private var newMessageHeightChanged = false
    private var isKeyboardVisibleLastState = false
    private var shouldAdjustContentForKeyboard = false

    private var commonKeyboardHeight: CGFloat = 0.0
    private var quoteHeightRelativeDelta: CGFloat = 0.0
    private var quoteHeightAbsoluteDelta: CGFloat = 0.0
    private var newMessageHeightRelativeDelta: CGFloat = 0.0
    private var newMessageHeightAbsoluteDelta: CGFloat = 0.0

    func adjustContentForKeyboard(shown: Bool, notification: NSNotification, model: KeyboardViewModel) {
        guard shouldAdjustContentForKeyboard else { return }

        let frameEnd = notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let animationDuration = notification.userInfo?[UIWindow.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? .zero
        let curve = notification.userInfo?[UIWindow.keyboardAnimationCurveUserInfoKey] as? UInt ?? .zero
        let animationCurve = UIView.AnimationOptions(rawValue: curve)
        let keyboardHeight = shown ? frameEnd.size.height : model.toolbarViewHeight
        let isKeyboardVisibleCurrentState = (keyboardHeight - model.toolbarViewHeight).rounded(.down) > 0
        let includeKeyboardHeight = isKeyboardVisibleCurrentState != isKeyboardVisibleLastState
        isKeyboardVisibleLastState = isKeyboardVisibleCurrentState

        defer {
            let defaultScrollButtonInset = keyboardHeight + 20
            self.delegate?.updateScrollButtonConstraints(defaultScrollButtonInset)
            self.delegate?.layoutIfNeeded()
        }

        UIView.animate(withDuration: animationDuration, delay: .zero, options: animationCurve) {
            // keyboardWillChange(_:) method call everytime when inputAccessoryViewHeight changed
            let excludeKeyboardHeight = (self.newMessageHeightChanged || self.quoteHeightChanged) && !includeKeyboardHeight
            guard !excludeKeyboardHeight else {
                self.adjustContentExcludeKeyboardHeight(
                    keyboardHeight: keyboardHeight,
                    model: model,
                    toolbarHeightRelativeDelta: self.toolbarHeightRelativeDelta
                )
                return
            }

            // This check prevent multiple call keyboardWillChange(_:) method.
            // First call when keyboardHeight is equal 0.
            // Second call when keyboardHeight is equal inputAccessoryViewHeight.
            let shouldSkipNotification = ((shown && keyboardHeight == model.toolbarViewHeight) || !includeKeyboardHeight)
            guard !shouldSkipNotification else { return }

            // Must record commonKeyboardheight for adjust content when keyboard will hide
            self.recordKeyboardHeightIfNeeded(shown: shown, keyboardHeight: keyboardHeight)
            self.adjustContentInset(shown: shown, model: model)

            // Check Is Interactive Dismiss Keyboard Gesture
            // FIXME: This check work time after time
            guard !model.isTracking else { return }

            self.adjustContentOffset(shown: shown, model: model)
        }
    }

    func set(shouldAdjustContentForKeyboard: Bool) {
        self.shouldAdjustContentForKeyboard = shouldAdjustContentForKeyboard
    }

    private func adjustContentExcludeKeyboardHeight(keyboardHeight: CGFloat, model: KeyboardViewModel, toolbarHeightRelativeDelta: CGFloat) {
        delegate?.setScrollIndicatorInset(model.scrollIndicatorContentInset + toolbarHeightRelativeDelta)
        delegate?.setScrollViewInset(model.scrollViewContentInset + toolbarHeightRelativeDelta)
        delegate?.setScrollViewOffset(model.scrollViewContentOffset + toolbarHeightRelativeDelta)
        resetDeltas()
    }

    private func adjustContentInset(shown: Bool, model: KeyboardViewModel) {
        let insetDelta: CGFloat = model.parentViewSafeArea
        let resultInset = shown ? commonKeyboardHeight - insetDelta + toolbarHeightAbsoluteDelta : toolbarHeightAbsoluteDelta
        self.delegate?.setScrollViewInset(resultInset)
        self.delegate?.setScrollIndicatorInset(resultInset)
    }

    private func adjustContentOffset(shown: Bool, model: KeyboardViewModel) {
        var offset = model.scrollViewContentOffset
        let offsetDelta = commonKeyboardHeight - model.parentViewSafeArea
        shown ? (offset += offsetDelta) : (offset -= offsetDelta)
        self.delegate?.setScrollViewOffset(offset)
    }

    private func recordKeyboardHeightIfNeeded(shown: Bool, keyboardHeight: CGFloat) {
        if shown {
            commonKeyboardHeight = keyboardHeight - toolbarHeightAbsoluteDelta
        }
    }

    private func resetDeltas() {
        self.newMessageHeightRelativeDelta = .zero
        self.quoteHeightRelativeDelta = .zero
        self.newMessageHeightChanged = false
        self.quoteHeightChanged = false
    }

}

extension KeyboardNotificationManager: HeightChangedHandlerProtcol {
    func heightChanged(from oldHeight: CGFloat, to newHeight: CGFloat, kind: HeightChangeKind) {
        let relativeDelta = newHeight - oldHeight
        switch kind {
        case .quote:
            quoteHeightChanged = true
            quoteHeightRelativeDelta = relativeDelta
            quoteHeightAbsoluteDelta = newHeight
        case .newMessage:
            newMessageHeightChanged = true
            newMessageHeightRelativeDelta = relativeDelta
            newMessageHeightAbsoluteDelta = newHeight - WMNewMessageView.initialInputTextViewHeight
        case .unknown:
            break
        }
    }
}

