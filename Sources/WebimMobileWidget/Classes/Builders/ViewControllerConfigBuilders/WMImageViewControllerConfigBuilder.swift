//
//  WMImageViewControllerConfigBuilder.swift
//  WebimWidget
//
//  Created by Аслан Кутумбаев on 26.01.2023.
//  
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
import UIKit

/**
 Image view controller config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Webim
 */
public class WMImageViewControllerConfigBuilder: WMViewControllerConfigBuilder {
    var saveViewColor: UIColor?

    /**
     - returns:
     `WMViewControllerConfig` object.
     Aslan Kutumbaev
     - copyright:
     2023 Webim
     */
    public override func build() -> WMViewControllerConfig {
        let imageControllerConfig = WMImageViewControllerConfig(viewControllerConfig: viewControllerConfig)
        imageControllerConfig.saveViewColor = saveViewColor
        return imageControllerConfig
    }

    /**
     Sets SaveView color.
     - parameter saveViewColor:
     SaveView color.
     - returns:
     `WMImageViewControllerConfigBuilder` object with SaveView color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Webim
     */
    public func set(saveViewColor: UIColor) -> Self {
        self.saveViewColor = saveViewColor
        return self
    }
}
