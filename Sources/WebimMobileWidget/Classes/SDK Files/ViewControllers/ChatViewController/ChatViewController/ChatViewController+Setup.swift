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
    
    static func createMessageDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.formatterBehavior = .behavior10_4
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter
    }
    
    func setupNavigationBar() {
        navigationBarUpdater.set(navigationController: navigationController)
        navigationBarUpdater.set(delegate: self)
        setupTitleView()
        setupRightBarButtonItem()
    }
    
    func setupLoadingView() {
        chatTableView.isHidden = true
        chatTableView.alpha = 0.0
        chatLoading.startAnimating()
    }

    func configureKeyboardNotificationManager() {
        keyboardNotificationManager.delegate = self
    }

    @objc func functionTap() {
        dismissViewKeyboard()
        clearTextViewSelection()
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(functionTap))
        tap.cancelsTouchesInView = false
        chatTableView.addGestureRecognizer(tap)
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
        toolbarView.messageView.delegate = self
        toolbarView.loadXibViewSetup()
    }
    
    func setupTitleView() {
        
        titleView.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
    
        navigationItem.titleView = titleView
    }
    
    private func setupRightBarButtonItem() {
        // RightBarButtonItem
        titleViewOperatorAvatarImageView.image = UIImage()
        
        let customViewForOperatorAvatar = createUIButton(type: .custom)
        customViewForOperatorAvatar.addSubview(titleViewOperatorAvatarImageView)
        
        titleViewOperatorAvatarImageView.snp.remakeConstraints { (make) -> Void in
            make.trailing.equalToSuperview()
                .inset(-14)
            make.width.equalTo(titleViewOperatorAvatarImageView.snp.height)
            make.top.bottom.equalToSuperview()
                .inset(2)
        }
        
        customViewForOperatorAvatar.addTarget(self, action: #selector(titleViewTapAction), for: .touchUpInside)
        
        
        let customRightBarButtonItem = UIBarButtonItem(
            customView: customViewForOperatorAvatar
        )
        
        navigationItem.rightBarButtonItem = customRightBarButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
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
        scrollButtonView.setScrollButtonViewState(.hidden)
        scrollButtonView.add(tapGesture: tapGesture)
        
        updateScrollButton()
    }
    
    func updateScrollButton() {
        let bottomInset = toolbarView.bounds.height + scrollButtonPadding + self.view.safeAreaInsets.bottom
        
        scrollButtonView.snp.remakeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(scrollButtonPadding)
            make.bottom.equalToSuperview().inset(bottomInset)
            make.height.equalTo(scrollButtonView.snp.width)
            make.width.equalTo(34)
        }
    }
    
    func setupTableViewDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: chatTableView, cellProvider: { tableView, indexPath, _ in
            self.updatedCellGeneration(for: indexPath, tableView: tableView)
        })
        chatTableView.dataSource = dataSource
    }
    
    func setupTableView() {
        let contentInset = toolbarView.bounds.height
        chatTableView.contentInset.bottom = contentInset
        chatTableView.verticalScrollIndicatorInsets.bottom = contentInset
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        chatTableView?.refreshControl = refreshControl
        refreshControl.tintColor = refreshControlTintColour
        let attributes = [NSAttributedString.Key.foregroundColor: refreshControlTextColour]
        refreshControl.addTarget(
            self,
            action: #selector(refreshMessages),
            for: .valueChanged
        )
        refreshControl.attributedTitle = NSAttributedString(
            string: "Fetching more messages...".localized,
            attributes: attributes
        )
    }

    func setupServerSideSettingsManager() {

        webimServerSideSettingsManager.getServerSideSettings(self)
    }
}


extension ChatViewController: ServerSideSettingsCompletionHandler {
    func onFailure() {
        DispatchQueue.main.async {
            self.toolbarView.messageView.fileButton.isHidden = false
        }
    }
    
    func onSuccess(webimServerSideSettings: ServerSettings) {
        webimServerSideSettingsManager.onSuccess(webimServerSideSettings: webimServerSideSettings)
        if webimServerSideSettingsManager.isRateOperatorEnabled() && webimServerSideSettingsManager.showRateOperatorButton() {
            let gestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(titleViewTapAction)
            )
            
            navigationItem.titleView?.addGestureRecognizer(gestureRecognizer)
            
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        DispatchQueue.main.async {
            self.toolbarView.messageView.fileButton.isHidden = !self.webimServerSideSettingsManager.getShowSendFileMenu()
        }
    }
}
