//
//  WMQuoteMessageCell.swift
//  WebimClientLibrary_Example
//
//  Created by EVGENII Loshchenko on 28.12.2021.
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

class WMQuoteMessageCell: WMMessageTableCell {
    
    @IBOutlet var quoteMessageText: UILabel!
    @IBOutlet var quoteAuthorName: UILabel!
    
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var quoteLineView: UIView!
    
    override func setMessage(message: Message) {
        super.setMessage(message: message)
        setupTextWithRefference()
        self.quoteMessageText.text = message.getQuote()?.getTranslationInfo()?.getTranslatedText() ?? message.getQuote()?.getMessageText()
        self.quoteAuthorName.text = message.getQuote()?.getSenderName()
        
        self.messageTextView.isUserInteractionEnabled = true
        for recognizer in messageTextView.gestureRecognizers ?? [] {
            if recognizer.isKind(of: UIPanGestureRecognizer.self) {
                recognizer.isEnabled = false
            }
        }
    }
    
    private func setupTextWithRefference() {
        let defaultTextColor = message.isVisitorType() ? quoteVisitorMessageTextColor : quoteOperatorMessageTextColor
        let defaultAuthorColor = message.isVisitorType() ? quoteVisitorMessageAuthorTextColor : quoteOperatorMessageAuthorTextColor
        let textColor = config?.subtitleAttributes?[.foregroundColor] as? UIColor ?? defaultTextColor
        let textFont = config?.subtitleAttributes?[.font] as? UIFont ?? messageTextView.notNilFont()
        let configTitleColor = message.isVisitorType() ? config?.subtitleAttributes?[.foregroundColor] as? UIColor : config?.titleAttributes?[.foregroundColor] as? UIColor
        let authorColor = configTitleColor ?? defaultAuthorColor
        self.quoteMessageText.textColor = textColor
        self.quoteAuthorName.textColor = authorColor
        self.quoteLineView.backgroundColor = authorColor
        
        let _ = self.messageTextView.setTextWithReferences(
            message.getData()?.getTranslationInfo()?.getTranslatedText() ?? message.getText(),
            textColor:  textColor,
            textFont: textFont,
            alignment: .left,
            linkColor: config?.linkColor
        )
    }
        
}
