//
//  WebimAccountConfigManager.swift
//  WebimClientLibrary_Example
//
//  Created by Аслан Кутумбаев on 09.06.2022.
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

class WebimServerSideSettingsManager {
    
    private var webimServerSideSettings: WebimServerSideSettings?
    
    func getServerSideSettings(_ completionHandler: ServerSideSettingsCompletionHandler) {
        WebimServiceController.currentSession.getServerSideSettings(completionHandler: completionHandler)
    }
    
    func isGlobalReplyEnabled() -> Bool {
        guard let isGlobalReplyEnabled = webimServerSideSettings?.accountConfig.webAndMobileQuoting else {
            return false
        }
        return isGlobalReplyEnabled
    }
    
    func isMessageEditEnabled() -> Bool {
        guard let isMessageEditEnabled = webimServerSideSettings?.accountConfig.visitorMessageEditing else {
            return false
        }
        return isMessageEditEnabled
    }
    
    func isRateOperatorEnabled() -> Bool {
        guard let isRateOperatorEnabled = webimServerSideSettings?.accountConfig.rateOperator else {
            return true
        }
        return isRateOperatorEnabled
    }
    
    func showRateOperatorButton() -> Bool {
        guard let showRateOperatorButton = webimServerSideSettings?.accountConfig.showRateOperator else {
            return true
        }
        return showRateOperatorButton
    }
    
    func getRateForm() -> String? {
        return webimServerSideSettings?.accountConfig.rateForm
    }
    
    func getRatedEntity() -> String? {
        return webimServerSideSettings?.accountConfig.ratedEntity
    }
    
    func getVisitorSegment() -> String? {
        webimServerSideSettings?.accountConfig.visitorSegment
    }
    
    func getProcessingPersonalDataUrl() -> String? {
        webimServerSideSettings?.accountConfig.processingPersonalDataUrl
    }
    
    func showProcessingPersonalDataCheckbox() -> Bool {
        webimServerSideSettings?.accountConfig.showProcessingPersonalDataCheckbox ?? false
    }
    
}

extension WebimServerSideSettingsManager: ServerSideSettingsCompletionHandler {
    func onSuccess(webimServerSideSettings: WebimServerSideSettings) {
        self.webimServerSideSettings = webimServerSideSettings
    }

    func onFailure() {

    }

}
