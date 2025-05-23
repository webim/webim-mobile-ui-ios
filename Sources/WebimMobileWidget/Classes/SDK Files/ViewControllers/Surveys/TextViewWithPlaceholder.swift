//
//  TextViewWithPlaceholder.swift
//  WebimClientLibrary_Example
//
//  Created by EVGENII Loshchenko on 13.08.2021.
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

class TextViewWithPlaceholder: UITextView {
    var placeholderLabel: UILabel = UILabel.createUILabel(systemFontSize: 16, numberOfLines: 0)
    func setPlaceholder(_ placeholder: String, placeholderColor: UIColor) {
        self.addSubview(placeholderLabel)
        self.placeholderLabel.font = self.font
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        /* self.placeholderLabel.snp.remakeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview().offset(6)
            make.width.equalToSuperview()
        }*/
        self.textViewDidChange()
    }
    
    func textViewDidChange() {
        if self.text.isEmpty {
            UIView.animate(withDuration: 0.1) {
                self.placeholderLabel.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.placeholderLabel.alpha = 0.0
            }
        }
    }
}
