//
//  WMBotButtonsTableViewCell.swift
//  WebimClientLibrary_Example
//
//  Created by Anna Frolova on 22.03.2022.
//  Copyright © 2022 Webim. All rights reserved.
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

import Foundation
import WebimMobileSDK
import UIKit

class WMBotButtonsTableViewCell: WMMessageTableCell {
    
    @IBOutlet var borderView: UIView!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var messageTextView: UITextView!
    private let SPACING_CELL: CGFloat = 6.0
    private let SPACING_DEFAULT: CGFloat = 10.0
    
    
    lazy var buttonsVerticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = SPACING_CELL
        return stackView
    }()
    
    private func emptyTheCell() {
        buttonsVerticalStack.removeFromSuperview()
        buttonsVerticalStack.removeAllArrangedSubviews()
        self.messageView?.isHidden = true
        self.messageTextView.text = ""
        self.buttonView.isHidden = false
    }

    override func applyConfig() { }
    
    override func setMessage(message: Message) {
        emptyTheCell()
        self.messageView?.alpha = 0
        self.buttonView.alpha = 1
        self.message = message
        buttonView.addSubview(buttonsVerticalStack)
        fillButtonsCell(message: message, showFullDate: true)
    }
    
    private func fillButtonsCell(
        message: Message,
        showFullDate: Bool
    ) {
        guard let keyboard = message.getKeyboard() else { return }
        let buttonsArray = keyboard.getButtons()
        let isActive = keyboard.getState() == .pending
        let config = self.config as? WMBotCellConfig
        self.time?.isHidden = true
        self.borderView.backgroundColor = config?.backgroundColor ?? buttonsBorderBackgroundColor
        
        let selectedButtonID = keyboard.getResponse()?.getButtonID()
        
        for buttonsStack in buttonsArray {
            for button in buttonsStack {
                let uiButton = UIButton(type: .system),
                    buttonID = button.getID(),
                    buttonText = button.getText()
                
                uiButton.accessibilityIdentifier = buttonID
                uiButton.setTitle(buttonText, for: .normal)
                uiButton.isUserInteractionEnabled = isActive
                /// add buttons only with text
                guard let titleLabel = uiButton.titleLabel else {
                    continue
                }
                if buttonID == selectedButtonID {
                    // set default buttons
                    uiButton.backgroundColor = config?.buttonChoosenBackgroundColor ?? buttonChoosenBackgroundColor
                    uiButton.tintColor = config?.buttonChoosenTitleColor ?? buttonChoosenTitleColor
                } else {
                    uiButton.backgroundColor = isActive
                    ? config?.buttonActiveBackgroundColor ?? buttonNotChoosenBackgroundColor
                    : config?.buttonCanceledBackgroundColor ?? buttonNotChoosenBackgroundColor
                    uiButton.tintColor = isActive
                    ? config?.buttonActiveTitleColor ?? buttonActiveTitleColor
                    : config?.buttonCanceledTitleColor ?? buttonCanceledTitleColor
                }
                if let roundCorners = config?.roundCorners,
                   let radius = config?.cornerRadius {
                    uiButton.roundCorners(roundCorners, radius: radius)
                }
                
                if let subtitleAttributes = config?.subtitleAttributes {
                    let attributedString = NSMutableAttributedString(
                        string: buttonText,
                        attributes: subtitleAttributes
                    )
                    titleLabel.attributedText = attributedString
                }

                titleLabel.lineBreakMode = .byWordWrapping
                titleLabel.numberOfLines = 0
                /// button text insets
                titleLabel.snp.remakeConstraints { make in
                    make.top.equalToSuperview().inset(10)
                    make.height.greaterThanOrEqualTo(18)
                    make.width.lessThanOrEqualToSuperview().inset(10)
                }
                
                uiButton.layer.borderWidth = config?.strokeWidth ?? 0
                uiButton.layer.borderColor = config?.strokeColor?.cgColor ?? buttonBorderColor.cgColor
                uiButton.clipsToBounds = true
                uiButton.translatesAutoresizingMaskIntoConstraints = false
                uiButton.layer.cornerRadius = config?.cornerRadius ?? 20
                
                if isActive {
                    uiButton.addTarget(
                        self,
                        action: #selector(sendButton),
                        for: .touchUpInside
                    )
                }
                
                buttonsVerticalStack.addArrangedSubview(uiButton)
                uiButton.snp.remakeConstraints { make in
                    make.trailing.equalToSuperview()
                    make.leading.equalToSuperview()
                }
                buttonsVerticalStack.sizeToFit()
            }
        }
        cellLayoutConstraintButtons(showFullDate: showFullDate)
    }
    
    private func cellLayoutConstraintButtons(showFullDate: Bool) {
        buttonsVerticalStack.snp.remakeConstraints { (make) -> Void in
            make.top.equalToSuperview()
                .inset(SPACING_DEFAULT)
            make.trailing.leading.equalToSuperview()
            make.height.lessThanOrEqualToSuperview().inset(10)
        }
        buttonsVerticalStack.sizeToFit()
    }
    
    @objc
    private func sendButton(sender: UIButton) {
        let messageID = message.getID()
        guard let title = sender.titleLabel?.text,
              let id = sender.accessibilityIdentifier
        else { return }
        sender.backgroundColor = buttonChoosenBackgroundColor
        sender.tintColor = buttonChoosenTitleColor
        print("Buttton \(title) with tag\\ID \(id) of message \(messageID) was tapped!")
        let buttonInfoDictionary = [
            "Message": messageID,
            "ButtonID": id,
            "ButtonTitle": title
        ]
        sendKeyboardRequest(keyboardRequest: buttonInfoDictionary)
        
        UIView.animate(withDuration: 1,
                       animations: { [weak self] in
            self?.messageView?.alpha = 1
            self?.buttonView.alpha = 0
        }, completion: nil)
    }
}
