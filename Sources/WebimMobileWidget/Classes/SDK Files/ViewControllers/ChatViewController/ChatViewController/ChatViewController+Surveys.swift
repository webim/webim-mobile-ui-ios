//
//  ChatViewController+SurveyListener.swift
//  WebimClientLibrary_Example
//
//  Created by EVGENII Loshchenko on 06.04.2021.
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

// MARK: - WEBIM: SurveyListener
extension ChatViewController: SurveyListener {
    
    func on(survey: Survey) {
        surveyCounter = 0
        let currentQuestion = survey.getCurrentQuestionInfo()
        for form in survey.getConfig().getDescriptor().getForms() {
            if form.getID() > currentQuestion.getFormID() {
                surveyCounter += form.getQuestions().count
            }
            if form.getID() == currentQuestion.getFormID() {
                surveyCounter += (form.getQuestions().count - currentQuestion.getQuestionID())
            }
        }
    }
    
    func on(nextQuestion: SurveyQuestion) {
        DispatchQueue.main.async {
            if self.rateStarsViewController != nil && self.rateStarsViewController?.isSurvey != true {
                self.delayedSurvayQuestion = nextQuestion
                return
            }
            self.delayedSurvayQuestion = nil
            self.surveyCounter -= 1
            let description = nextQuestion.getText()
            
            let operatorId = ""
            switch nextQuestion.getType() {
            case .comment:
                self.showSurveyCommentDialog(description: description)
            case .radio:
                self.showSurveyRadioButtonDialog(description: description, points: nextQuestion.getOptions() ?? [])
            case .stars:
                self.showRateStars(operatorId: operatorId, isSurvey: true, description: description)
            }
        }
    }
    
    func onSurveyCancelled() {
        surveyCounter = 0
        self.surveyCommentViewController?.closeViewController()
        self.rateStarsViewController?.closeViewController()
        self.surveyRadioButtonViewController?.closeViewController()
        
        self.rateStarsViewController = nil
        self.surveyRadioButtonViewController = nil
        self.surveyCommentViewController = nil
        
        self.delayedSurvayQuestion = nil
    }
}

// MARK: - WEBIM: Survey
extension ChatViewController {
    
    func showRateOperatorDialog(operatorId: String?) {
        if let operatorId = operatorId {
            self.showRateStars(operatorId: operatorId, isSurvey: false, description: "")
        }
    }
    
    func showRateOperatorDialog() {
        showRateOperatorDialog(operatorId: currentOperatorId())
    }
    
    func currentOperatorId() -> String? {
        if let operatorId = WebimServiceController.currentSession.getCurrentOperator()?.getID() {
            return operatorId
        }
        
        for message in chatMessages.reversed() {
            if let operatorId = message.getOperatorID() {
                return operatorId
            }
        }
        return nil
    }

    func isCurrentOperatorRated() -> Bool? {

        if let operatorId = WebimServiceController.currentSession.getCurrentOperator()?.getID() {
            return alreadyRatedOperators[operatorId]
        }

        for message in chatMessages.reversed() {
            if let operatorId = message.getOperatorID() {
                return alreadyRatedOperators[operatorId]
            }
        }
        return nil
    }
    
    func showRateStarsDialog(description: String) {
        
        self.showRateStars(operatorId: "", isSurvey: true, description: description)
    }
    
    private func showRateStars(operatorId: String, isSurvey: Bool, description: String) {
        DispatchQueue.main.async {
            
            let vc = RateStarsViewController.loadViewControllerFromXib()
            let chatConfig = self.chatConfig as? WMChatViewControllerConfig
            vc.delegate = self
            vc.rateOperatorDelegate = self
            vc.config = chatConfig?.surveyViewConfig
            self.rateStarsViewController = vc
            vc.operatorId = operatorId
            vc.isSurvey = isSurvey
            vc.descriptionText = description
            vc.modalPresentationStyle = .overCurrentContext
            vc.currentRating = self.alreadyRatedOperators[operatorId] != true ? 0.0 : Double(WebimServiceController.shared.currentSession().getLastRatingOfOperatorWith(id: operatorId))
            self.present(vc, animated: true) {
                UIView.animate(withDuration: 0.3) { [weak vc] in
                    vc?.view.backgroundColor = .black.withAlphaComponent(0.5)
                }
            }
        }
    }
    
    func showSurveyCommentDialog(description: String) {
        DispatchQueue.main.async {
            
            let vc = SurveyCommentViewController.loadViewControllerFromXib()
            self.surveyCommentViewController = vc
            vc.descriptionText = description
            vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func showSurveyRadioButtonDialog(description: String, points: [String]) {
        
        DispatchQueue.main.async {
            let vc = SurveyRadioButtonViewController.loadViewControllerFromXib()
            self.surveyRadioButtonViewController = vc
            vc.descriptionText = description
            vc.points = points
            vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(vc, animated: false, completion: nil)
            
        }
    }
}

extension ChatViewController: RateStarsViewControllerDelegate, WMSurveyViewControllerDelegate {
    func rateOperator(operatorID: String, rating: Int) {
        WebimServiceController.currentSession.rateOperator(
            withID: operatorID,
            byRating: rating,
            completionHandler: self
        )
    }
    
    @objc
    func sendSurveyAnswer(_ surveyAnswer: String) {
        WebimServiceController.currentSession.send(
            surveyAnswer: surveyAnswer,
            completionHandler: self
        )
    }
    
    func surveyViewControllerClosed() {
        WebimServiceController.currentSession.closeSurvey()
    }
}

// MARK: - WEBIM: CompletionHandlers
extension ChatViewController: RateOperatorCompletionHandler, SendSurveyAnswerCompletionHandler, SendResolutionCompletionHandler {
    
    func onSuccess() {
        if self.delayedSurvayQuestion == nil && self.surveyCounter == 0 {
            self.thanksView.showAlert()
            if surveyCounter == 0 {
                surveyCounter = -1
            }
            guard let currentOperator = WebimServiceController.currentSession.getCurrentOperator() else {
                return
            }
            let sessionState = WebimServiceController.currentSession.sessionState()
            
            if sessionState != .closedByOperator && sessionState != .closedByVisitor {
                alreadyRatedOperators[currentOperator.getID()] = true
            }
            changed(operator: WebimServiceController.currentSession.getCurrentOperator(),
                    to: WebimServiceController.currentSession.getCurrentOperator())
        }
    }
    
    func onFailure(error: RateOperatorError) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.41) {
            var message = String()
            switch error {
            case .noChat:
                message = "There is no current agent to rate".localized
            case .wrongOperatorId:
                message = "This agent not in the current chat".localized
            case .noteIsTooLong:
                message = "Note for rate is too long".localized
            case .rateDisabled:
                message = "Rate is disabled".localized
            case .operatorNotInChat:
                message = "No operator for rate in chat".localized
            case .rateValueIncorrect:
                message = "Incorrect rate value".localized
            case .unknown:
                message = "Rate operator error".localized
            }
            
            self.alertDialogHandler.showDialog(
                withMessage: message,
                title: "Operator rating failed".localized
            )
        }
    }
    
    func onFailure(error: SendResolutionError) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.41) {
            var message = String()
            switch error {
            case .noChat:
                message = "There is no current agent to rate".localized
            case .rateDisabled:
                message = "Rate is disabled".localized
            case .operatorNotInChat:
                message = "No operator for rate in chat".localized
            case .resolutionSurveyValueIncorrect:
                message = "Incorrect resolution survey value".localized
            case .unknown:
                message = "Send resolution error".localized
            case .rateFormMismatch:
                message = "rateFormMismatch error".localized
            case .visitorSegmentMismatch:
                message = "visitorSegmentMismatch error".localized
            case .ratedEntityMismatch:
                message = "ratedEntityMismatch error".localized
            }
            
            self.alertDialogHandler.showDialog(
                withMessage: message,
                title: "Operator rating failed".localized
            )
        }
    }
    
    // SendSurveyAnswerCompletionHandler
    func onFailure(error: SendSurveyAnswerError) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.41) {
            var message = String()
            switch error {
            case .incorrectRadioValue:
                message = "Incorrect radio value".localized
            case .incorrectStarsValue:
                message = "Incorrect stars value".localized
            case .incorrectSurveyID:
                message = "Incorrect survey ID".localized
            case .maxCommentLength_exceeded:
                message = "Comment is too long".localized
            case .noCurrentSurvey:
                message = "No current survey".localized
            case .questionNotFound:
                message = "Question not found".localized
            case .surveyDisabled:
                message = "Survey disabled".localized
            case .unknown:
                message = "Unknown error".localized
            }
            
            self.alertDialogHandler.showDialog(
                withMessage: message,
                title: "Failed to send survey answer".localized
            )
        }
    }
}
