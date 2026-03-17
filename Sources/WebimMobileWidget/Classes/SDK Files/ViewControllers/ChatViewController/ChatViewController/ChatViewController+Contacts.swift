//
//  ChatViewController+Contacts.swift
//  Pods
//
//  Created by Anna Frolova on 23.09.2024.
//

import WebimMobileSDK
import UIKit

extension ChatViewController {
    func showContactViewController() {
        DispatchQueue.main.async {
            let vc = ContactsViewController.loadViewControllerFromXib()
            let chatConfig = self.chatConfig as? WMChatViewControllerConfig
            vc.delegate = self
            vc.config = chatConfig?.contactsViewConfig
            vc.webimServerSideSettingsManager = self.webimServerSideSettingsManager
            vc.visitorInfo = WebimServiceController.currentSession.getVisitor()?.getVisitorFieldsInDictionary()
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true) {
                UIView.animate(withDuration: 0.3) { [weak vc] in
                    vc?.view.backgroundColor = .black.withAlphaComponent(0.5)
                }
            }
        }
    }
}

extension ChatViewController: ContactsViewControllerDelegate {
    func sendContactsAnswer(_ contacts: String) {
        WebimServiceController.currentSession.sendContacts(contacts: contacts, completionHandler: self)
    }
}

extension ChatViewController: ContactsCompletionHandler {
    func onFailure(error: ContactsError) {
    }
}

extension ChatViewController: FirstQuestionControllerDelegate {
    
    func firstQuestionSave(message: String,
                           visitorFields: String?,
                           viewType: ViewType,
                           file: Data?,
                           fileName: String?,
                           mimeType: String?) {
        if viewType == .firstQuestion {
            WebimServiceController.currentSession.startChat(firstQuestion: message,
                                                            customFields: visitorFields)
        } else {
            guard let fields = visitorFields else { return }
            WebimServiceController.currentSession.sendOfflineMessage(message: message,
                                                                     fields: fields,
                                                                     file: file,
                                                                     fileName: fileName,
                                                                     mimeType: mimeType,
                                                                     completionHandler: self)
        }
    }
    
    func firstQuestionClosed() {
        self.popViewController()
    }
}

extension ChatViewController: OfflineMessageCompletionHandler {
    func onFailure(error: OfflineMessageError) {
        firstQuestionClosed()
    }
    
    func onSuccess(offlineMessageId: String) {
        firstQuestionClosed()
    }
}
