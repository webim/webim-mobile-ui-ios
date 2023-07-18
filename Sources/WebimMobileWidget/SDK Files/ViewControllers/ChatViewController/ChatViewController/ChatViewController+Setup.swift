//
//  ChatViewController+UIView.swift
//  WebimClientLibrary_Example
//
//  Created by EVGENII Loshchenko on 11.05.2021.
//  Copyright © 2021 Webim. All rights reserved.
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
import WebimMobileSDK

extension UILabel {
    static func createUILabel(
        textAlignment: NSTextAlignment = .left,
        systemFontSize: CGFloat,
        systemFontWeight: UIFont.Weight = .regular,
        numberOfLines: Int = 1
    ) -> UILabel {
        let label = UILabel()
        label.textAlignment = textAlignment
        label.font = .systemFont(ofSize: systemFontSize, weight: .regular )
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension ChatViewController {

    func createTextInputTextView() -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    
    func createUIView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func createUIImageView(
        contentMode: UIView.ContentMode = .scaleAspectFit
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func createUIButton(type: UIButton.ButtonType) -> UIButton {
        let button = UIButton(type: type)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func createCustomUIButton(type: UIButton.ButtonType) -> UIButton {
        let button = CustomUIButton(type: type)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func setupNavigationBar() {
        navigationBarUpdater.set(navigationController: navigationController)
        navigationBarUpdater.set(delegate: self)
        setupTitleView()
        setupRightBarButtonItem()
    }

    func configureKeyboardNotificationManager() {
        keyboardNotificationManager.delegate = self
    }
    
    func addDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissViewKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc func functionTap() {
        dismissViewKeyboard()
        clearTextViewSelection()
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(functionTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupTestView() {
        if WMTestManager.testModeEnabled() {
            chatTestView.setupView(delegate: self)
            self.view.addSubview(chatTestView)
            chatTestView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            chatTestView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            chatTestView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            self.view.bringSubviewToFront(chatTestView)
        }
    }

    func configureToolbarView() {
        self.toolbarView.messageView.delegate = self

        self.toolbarView.quoteView.heightChangedHandler = keyboardNotificationManager
        self.toolbarView.messageView.heightChangedHandler = keyboardNotificationManager

        self.toolbarBackgroundView.addSubview(toolbarView)
        self.toolbarView.setup()
    }
    
    func setupTitleView() {

        titleView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(80)
        }

        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(titleViewTapAction)
        )

        titleView.addGestureRecognizer(gestureRecognizer)
        navigationItem.titleView = titleView
    }
    
    private func setupRightBarButtonItem() {
        // RightBarButtonItem
        titleViewOperatorAvatarImageView.image = UIImage()
        
        let customViewForOperatorAvatar = createUIView()
        customViewForOperatorAvatar.addSubview(titleViewOperatorAvatarImageView)
        
        titleViewOperatorAvatarImageView.snp.remakeConstraints { (make) -> Void in
            make.trailing.equalToSuperview()
                .inset(-14)
            make.width.equalTo(titleViewOperatorAvatarImageView.snp.height)
            make.top.bottom.equalToSuperview()
                .inset(2)
        }
        
        let customRightBarButtonItem = UIBarButtonItem(
            customView: customViewForOperatorAvatar
        )
        
        navigationItem.rightBarButtonItem = customRightBarButtonItem
        navigationItem.rightBarButtonItem?.action = #selector(titleViewTapAction)
    }
    
    func configureNetworkErrorView() {
        self.connectionErrorView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25)
        self.connectionErrorView.alpha = 0
        self.view.addSubviewWithSameWidth(connectionErrorView)
    }
    
    func configureThanksView() {
        self.view.addSubviewWithSameWidth(thanksView)
        self.thanksView.hideWithoutAnimation()
    }
    
    func setupScrollButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollToUnreadMessage))
        view.addSubview(scrollButtonView)
        scrollButtonView.initialSetup()
        scrollButtonView.setScrollButtonBackgroundImage(scrollButtonImage, state: .normal)
        scrollButtonView.add(tapGesture: tapGesture)
        scrollButtonView.setScrollButtonViewState(.hidden)
        setupScrollButtonViewConstraints()
    }

    private func setupScrollButtonViewConstraints() {
        scrollButtonView.snp.makeConstraints { make in
            let scrollButtonPadding: CGFloat = 22
            if #available(iOS 11.0, *) {
                make.trailing.equalTo(view.safeAreaLayoutGuide).inset(scrollButtonPadding)
            } else {
                make.trailing.equalToSuperview().inset(scrollButtonPadding)
            }
            make.bottom.equalToSuperview().inset(toolbarView.frame.height + scrollButtonPadding)
            make.height.equalTo(scrollButtonView.snp.width)
            make.width.equalTo(34)
        }
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        chatTableView?.refreshControl = refreshControl
        refreshControl.tintColor = refreshControlTintColour
        let attributes = [NSAttributedString.Key.foregroundColor: refreshControlTextColour]
        refreshControl.addTarget(
            self,
            action: #selector(requestMessages),
            for: .valueChanged
        )
        refreshControl.attributedTitle = NSAttributedString(
            string: "Fetching more messages...".localized,
            attributes: attributes
        )
    }
    
    func configureNotifications() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
         
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dismissViewKeyboard),
            name: UIApplication.willResignActiveNotification,
            object: nil)
        
    }

    func setupServerSideSettingsManager() {
        webimServerSideSettingsManager.getServerSideSettings()
    }

    func setupAlreadyRatedOperators() {
        guard let alreadyRatedOperatorsDictionary = WMKeychainWrapper.standard.dictionary(
            forKey: keychainKeyRatedOperators) as? [String: Bool] else {
            return
        }
        alreadyRatedOperators = alreadyRatedOperatorsDictionary
    }

    func setupSafeArea() {
        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets.bottom = inputAccessoryView?.bounds.height ?? 55
        }
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        self.keyboardNotificationManager.adjustContentForKeyboard(
            shown: true,
            notification: notification,
            model: self.currentKeyboardViewModel())
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.keyboardNotificationManager.adjustContentForKeyboard(
            shown: false,
            notification: notification,
            model: self.currentKeyboardViewModel())
    }

    private func currentKeyboardViewModel() -> KeyboardViewModel {
        var verticalScrollIndicatorInset: CGFloat
        var parentViewSafeArea: CGFloat
        if #available(iOS 11.1, *) {
            verticalScrollIndicatorInset = chatTableView.verticalScrollIndicatorInsets.bottom
            parentViewSafeArea = view.safeAreaInsets.bottom
        } else {
            verticalScrollIndicatorInset = .zero
            parentViewSafeArea = .zero
        }
        return KeyboardViewModel(parentViewSafeArea: parentViewSafeArea,
                                 toolbarViewHeight: toolbarBackgroundView.bounds.height,
                                 scrollViewContentOffset: chatTableView.contentOffset.y,
                                 scrollViewContentInset: chatTableView.contentInset.bottom,
                                 scrollIndicatorContentInset: verticalScrollIndicatorInset,
                                 isTracking: chatTableView.isTracking)
    }
}
