//
//  WMFastCustomizationConfigBuilder.swift
//  WebimMobileWidget
//
//  Created by Anna Frolova on 01.09.2025.
//

import Foundation
import UIKit
import Cosmos

/**
 Fast customization chat view controller config.
 - author:
 Anna Frolova
 - copyright:
 2025 Webim
 */

public class WMFastCustomizationConfigBuilder: WMChatViewControllerConfigBuilder {
    private var firstColor: UIColor = #colorLiteral(red: 0.08235294118, green: 0.6745098039, blue: 0.8235294118, alpha: 1)
    private var secondColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.1607843137, blue: 0.3176470588, alpha: 1)
    private var thirdColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private var fourthColor: UIColor = #colorLiteral(red: 0.3607843137, green: 0.3725490196, blue: 0.5411764706, alpha: 1)
    private var fifthColor: UIColor = #colorLiteral(red: 0.6941176471, green: 0.7019607843, blue: 0.7098039216, alpha: 1)
    private var sixthColor: UIColor = #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.9529411765, alpha: 1)
    private var seventhColor: UIColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
    private var eighthColor: UIColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
    private var textSize: CGFloat = 16
    private var cornerRadius: CGFloat = 10
    private var linkColor: UIColor = #colorLiteral(red: 0.1977989972, green: 0.5007162094, blue: 0.9563334584, alpha: 1)
    
    private let centerAligmentParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
    }()
    
    /**
     - returns:
     `WMViewControllerConfig` object with config.
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public override func build() -> WMViewControllerConfig {
        return chatViewControllerConfig()
    }
    
    // MARK: Helpers
    /**
     Sets visitor message background and send state, operator message name and file, bot buttton title, selected bot button color.
     - parameter firstColor:
     Color.
     - returns:
     `WMFastCustomizationConfigBuilder` object with first color set.
     - author:
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(firstColor: UIColor) -> Self {
        self.firstColor = firstColor
        return self
    }
    
    /**
     Sets navigation bar, operator text message, new message text, rate form text color.
     - parameter secondColor:
     Color.
     - returns:
     `WMFastCustomizationConfigBuilder` object with second color set.
     - author:
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(secondColor: UIColor) -> Self {
        self.secondColor = secondColor
        return self
    }
    
    /**
     Sets operator background, bot background, visitor message text, navigation text, new message background, rate button text, rate bsckground color.
     - parameter thirdColor:
     Color.
     - returns:
     `WMFastCustomizationConfigBuilder` object with third color set.
     - author:
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(thirdColor: UIColor) -> Self {
        self.thirdColor = thirdColor
        return self
    }
    
    /**
     Sets system message, time, rate stars, mew message inactive color.
     - parameter fourthColor:
     Color.
     - returns:
     `WMFastCustomizationConfigBuilder` object with fourth color set.
     - author:
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(fourthColor: UIColor) -> Self {
        self.fourthColor = fourthColor
        return self
    }
    
    /**
     Sets network error background color, rate star inactive color..
     - parameter fifthColor:
     Color.
     - returns:
     `WMFastCustomizationConfigBuilder` object with fifth color set.
     - author:
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(fifthColor: UIColor) -> Self {
        self.fifthColor = fifthColor
        return self
    }
    
    /**
     Sets chat background color.
     - parameter sixthColor:
     Color.
     - returns:
     `WMFastCustomizationConfigBuilder` object with sixth color set.
     - author:
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(sixthColor: UIColor) -> Self {
        self.sixthColor = sixthColor
        return self
    }
    
    /**
     Sets seventh color.
     - parameter seventhСolor:
     Color.
     - returns:
     `WMFastCustomizationConfigBuilder` object with chat background color set.
     - author:
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(seventhColor: UIColor) -> Self {
        self.seventhColor = seventhColor
        return self
    }
    
    /**
     Sets popup delete text and icon color.
     - parameter eighthСolor:
     Color.
     - returns:
     `WMFastCustomizationConfigBuilder` object with eighth color set.
     - author:
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(eighthColor: UIColor) -> Self {
        self.eighthColor = eighthColor
        return self
    }
    
    /**
     Sets open from notification.
     - parameter textSize:
     If **true** scroll to first unread message on first appear.
     Default value - **false**
     - returns:
     `WMFastCustomizationConfigBuilder` object with show scroll button view set.
     - author:
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(textSize: CGFloat) -> Self {
        self.textSize = textSize
        return self
    }
    
    /**
     Sets open from notification.
     - parameter cornerRadius:
     If **true** scroll to first unread message on first appear.
     Default value - **false**
     - returns:
     `WMFastCustomizationConfigBuilder` object with show scroll button view set.
     - author:
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        return self
    }
    
    /**
     Sets link Color.
     - parameter linkColor:
     Link color.
     - returns:
     `WMFastCustomizationConfigBuilder` object with link color set.
     - author:
     Anna Frolova
     - copyright:
     2026 Webim
     */
    public func set(linkColor: UIColor) -> Self {
        self.linkColor = linkColor
        return self
    }
}

extension WMFastCustomizationConfigBuilder {
    private func buildVisitorCellsConfig() -> WMCellsConfig {
        let textCellSubtitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font: UIFont.systemFont(ofSize: textSize, weight: .regular),
            .foregroundColor: thirdColor
        ]
        let textCellConfig = WMTextCellConfigBuilder()
            .set(backgroundColor: firstColor)
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMinXMaxYCorner])
            .set(cornerRadius: cornerRadius)
            .set(subtitleAttributes: textCellSubtitleAttributes)
            .set(messageReadIcon: messageReadIcon.withTintColor(firstColor))
            .set(messageUnreadIcon: messageUnreadIcon.withTintColor(fourthColor.withAlphaComponent(0.6)))
            .set(timeColor: fourthColor.withAlphaComponent(0.6))
            .set(linkColor: linkColor)
            .build()
        
        let imageCellConfig = WMImageCellConfigBuilder()
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMaxXMaxYCorner,
                                .layerMinXMaxYCorner])
            .set(cornerRadius: cornerRadius)
            .set(timeColor: fourthColor.withAlphaComponent(0.6))
            .set(messageReadIcon: messageReadIcon.withTintColor(firstColor))
            .set(messageUnreadIcon: messageUnreadIcon.withTintColor(fourthColor.withAlphaComponent(0.6)))
            .build()
        
        let fileCellTitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font: UIFont.systemFont(ofSize: textSize - 2, weight: .regular),
            .foregroundColor: thirdColor
        ]
        let fileCellSubtitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font : UIFont.systemFont(ofSize: textSize - 3, weight: .regular),
            .foregroundColor : thirdColor
        ]
        let fileCellConfig = WMFileCellConfigBuilder()
            .set(backgroundColor: firstColor)
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMinXMaxYCorner])
            .set(cornerRadius: cornerRadius)
            .set(titleAttributes: fileCellTitleAttributes)
            .set(subtitleAttributes: fileCellSubtitleAttributes)
            .set(fileImage: fileDownloadButtonImage, for: .download)
            .set(fileImage: fileDownloadSuccessImage, for: .ready)
            .set(fileImage: fileUploadButtonVisitorImage, for: .upload)
            .set(fileImage: fileDownloadErrorImage, for: .error)
            .set(fileImageColor: thirdColor, for: .download)
            .set(fileImageColor: thirdColor, for: .ready)
            .set(fileImageColor: thirdColor, for: .upload)
            .set(fileImageColor: eighthColor, for: .error)
            .set(timeColor: fourthColor.withAlphaComponent(0.6))
            .set(messageReadIcon: messageReadIcon.withTintColor(firstColor))
            .set(messageUnreadIcon: messageUnreadIcon.withTintColor(fourthColor.withAlphaComponent(0.6)))
            .build()
        
        let visitorCellsConfig = WMCellsConfigBuilder()
            .set(textCellConfig: textCellConfig)
            .set(imageCellConfig: imageCellConfig)
            .set(fileCellConfig: fileCellConfig)
            .build()
        
        return visitorCellsConfig
    }
    
    private func buildOperatorCellsConfig() -> WMCellsConfig {
        let cellTitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font: UIFont.systemFont(ofSize: textSize - 2, weight: .regular),
            .foregroundColor: firstColor
        ]
        let textCellSubtitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font: UIFont.systemFont(ofSize: textSize, weight: .regular),
            .foregroundColor: secondColor
        ]
        let textCellConfig = WMTextCellConfigBuilder()
            .set(backgroundColor: thirdColor)
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMaxXMaxYCorner])
            .set(cornerRadius: cornerRadius)
            .set(titleAttributes: cellTitleAttributes)
            .set(subtitleAttributes: textCellSubtitleAttributes)
            .set(timeColor: fourthColor.withAlphaComponent(0.6))
            .set(linkColor: linkColor)
            .build()
        
        let imageCellConfig = WMImageCellConfigBuilder()
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMaxXMaxYCorner,
                                .layerMinXMaxYCorner])
            .set(cornerRadius: cornerRadius)
            .set(timeColor: fourthColor.withAlphaComponent(0.6))
            .build()
        
        let fileCellSubtitleAttribute: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font : UIFont.systemFont(ofSize: textSize, weight: .regular),
            .foregroundColor : secondColor
        ]
        let fileCellConfig = WMFileCellConfigBuilder()
            .set(backgroundColor: thirdColor)
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMaxXMaxYCorner])
            .set(cornerRadius: cornerRadius)
            .set(titleAttributes: cellTitleAttributes)
            .set(subtitleAttributes: fileCellSubtitleAttribute)
            .set(fileImage: fileDownloadButtonImage, for: .download)
            .set(fileImage: fileDownloadSuccessImage, for: .ready)
            .set(fileImage: fileUploadButtonVisitorImage, for: .upload)
            .set(fileImage: fileDownloadErrorImage, for: .error)
            .set(fileImageColor: firstColor, for: .download)
            .set(fileImageColor: firstColor, for: .ready)
            .set(fileImageColor: firstColor, for: .upload)
            .set(fileImageColor: eighthColor, for: .error)
            .set(timeColor: fourthColor.withAlphaComponent(0.6))
            .build()
        
        let operatorCellsConfig = WMCellsConfigBuilder()
            .set(textCellConfig: textCellConfig)
            .set(imageCellConfig: imageCellConfig)
            .set(fileCellConfig: fileCellConfig)
            .build()
        
        return operatorCellsConfig
    }
    
    private func chatViewControllerConfig() -> WMViewControllerConfig {
        let visitorCellsConfig = buildVisitorCellsConfig()
        let operatorCellsConfig = buildOperatorCellsConfig()
        
        let infoCellLabelAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                return paragraphStyle
            }(),
            .font: UIFont.systemFont(ofSize: textSize - 4, weight: .regular),
            .foregroundColor: fourthColor
        ]
        let infoCellConfig = WMAbstractCellConfigBuilder()
            .set(cornerRadius: cornerRadius)
            .set(timeColor: fourthColor)
            .set(titleAttributes: infoCellLabelAttributes)
            .build()
        
        let botButtonLabelAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                return paragraphStyle
            }(),
            .font: UIFont.systemFont(ofSize: textSize - 3, weight: .regular),
            .foregroundColor: firstColor
        ]
        
        let botButtonCellConfig = WMBotCellConfigBuilder()
            .set(backgroundColor: fourthColor.withAlphaComponent(0.1))
            .set(buttonChoosenTitleColor: thirdColor)
            .set(buttonActiveTitleColor: firstColor)
            .set(buttonCanceledTitleColor: fourthColor.withAlphaComponent(0.5))
            .set(buttonChoosenBackgroundColor: firstColor)
            .set(buttonActiveBackgroundColor: thirdColor)
            .set(buttonCanceledBackgroundColor: thirdColor)
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMaxXMaxYCorner,
                                .layerMinXMaxYCorner])
            .set(cornerRadius: 20)
            .set(subtitleAttributes: botButtonLabelAttributes)
            .set(strokeWidth: 0)
            .set(strokeColor: buttonBorderColor)
            .build()
        let toolBarConfig = WMToolbarConfigBuilder()
            .set(sendButtonImage: textInputButtonImage.withTintColor(fourthColor))
            .set(inactiveSendButtonImage: textInputButtonImage.withTintColor(fourthColor.withAlphaComponent(0.5)))
            .set(addAttachmentImage: addAttachmentImage.withTintColor(fourthColor.withAlphaComponent(0.5)))
            .set(placeholderText: "Enter message".localized)
            .set(textViewFont: .systemFont(ofSize: textSize, weight: .regular))
            .set(textViewStrokeWidth: 1)
            .set(emptyTextViewStrokeColor: fourthColor.withAlphaComponent(0.5))
            .set(filledTextViewStrokeColor: fourthColor)
            .set(textViewCornerRadius: 17)
            .set(textViewMaxHeight: 90)
            .set(toolbarBackgroundColor: thirdColor)
            .build()
        let networkErrorViewConfig = WMNetworkErrorViewConfigBuilder()
            .set(image: networkError)
            .set(text: "Connection error".localized)
            .set(backgroundColor: fifthColor)
            .set(textColor: .white)
            .build()
        let replyCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: replyImage)
            .set(actionText: "Reply".localized)
            .build()
        let copyCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: copyImage)
            .set(actionText: "Copy".localized)
            .build()
        let editCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: editImage)
            .set(actionText: "Edit".localized)
            .build()
        let deleteCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: deleteImage)
            .set(actionText: "Delete".localized)
            .build()
        let likeCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: editImage)
            .set(actionText: "Like".localized)
            .build()
        let dislikeCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: editImage)
            .set(actionText: "Dislike".localized)
            .build()
        let popupActionControllerConfig = WMPopupActionControllerConfigBuilder()
            .set(cornerRadius: 20)
            .set(strokeWidth: 0)
            .set(strokeColor: .clear)
            .set(cellsHeight: 40)
            .set(cellConfig: replyCellConfig, for: .reply)
            .set(cellConfig: copyCellConfig, for: .copy)
            .set(cellConfig: editCellConfig, for: .edit)
            .set(cellConfig: deleteCellConfig, for: .delete)
            .set(cellConfig: likeCellConfig, for: .like)
            .set(cellConfig: dislikeCellConfig, for: .dislike)
            .build()
        let quoteViewConfig = WMQuoteViewConfigBuilder()
            .set(backgroundColor: .white)
            .set(quoteViewBackgroundColor: .white)
            .set(quoteTextColor: secondColor)
            .set(authorTextColor: secondColor)
            .set(quoteTextFont: .systemFont(ofSize: textSize - 2, weight: .regular))
            .set(authorTextFont: .systemFont(ofSize: textSize - 2, weight: .bold))
            .set(quoteLineColor: firstColor)
            .set(height: 71)
            .build()
        let editBarConfig = quoteViewConfig
        let rateOperatorButtonTitle = NSAttributedString(
            string: "Send".localized,
            attributes: [.font: UIFont.systemFont(ofSize: textSize + 4, weight: .semibold),
                         .foregroundColor: UIColor.white,
                         .paragraphStyle: self.centerAligmentParagraphStyle])
        let surveyViewConfig = WMSurveyViewConfigBuilder()
            .set(cosmosSettings: defaultCosmosSettings())
            .set(starsViewSize: CGSize(width: 170, height: 43))
            .set(buttonTitle: rateOperatorButtonTitle)
            .set(buttonColor: firstColor)
            .set(buttonCornerRadius: 8)
            .build()
        let chatNavigationBarConfig = WMChatNavigationBarConfigBuilder()
            .set(backgroundColorOnlineState: secondColor)
            .set(backgroundColorOfflineState: secondColor.withAlphaComponent(0.5))
            .set(textColorOnlineState: thirdColor)
            .set(textColorOfflineState: thirdColor)
            .set(logoImage: navigationBarTitleImageViewImage)
            .set(canShowTypingIndicator: true)
            .set(typingLabelText: "typing".localized)
            .build()
        
        let refreshControlAttributedTitle = NSAttributedString(
            string: "Fetching more messages...".localized,
            attributes: [NSAttributedString.Key.foregroundColor: fifthColor])
        
        let chatConfig = WMChatViewControllerConfigBuilder()
            .set(showScrollButtonView: self.showScrollButtonView ?? true)
            .set(forceOnline: self.forceOnline ?? false)
            .set(scrollButtonImage: (self.scrollButtonImage ?? scrollButton.withTintColor(secondColor)))
            .set(showScrollButtonCounter: self.showScrollButtonCounter ?? true)
            .set(requestMessagesCount: self.requestMessagesCount ?? 25)
            .set(refreshControlAttributedTitle: self.refreshControlAttributedTitle ?? refreshControlAttributedTitle)
            .set(refreshControlTintColor: self.refreshControlTintColor ?? fourthColor)
            .set(visitorCellsConfig: self.visitorCellsConfig ?? visitorCellsConfig)
            .set(operatorCellsConfig: self.operatorCellsConfig ?? operatorCellsConfig)
            .set(botButtonsConfig: self.botButtonsConfig ?? botButtonCellConfig)
            .set(toolbarConfig: self.toolbarConfig ?? toolBarConfig)
            .set(networkErrorViewConfig: self.networkErrorViewConfig ?? networkErrorViewConfig)
            .set(popupActionControllerConfig: self.popupActionControllerConfig ?? popupActionControllerConfig)
            .set(quoteViewConfig: self.quoteViewConfig ?? quoteViewConfig)
            .set(editBarConfig: self.editBarConfig ?? editBarConfig)
            .set(surveyViewConfig: self.surveyViewConfig ?? surveyViewConfig)
            .set(navigationBarConfig: self.viewControllerConfig.navigationBarConfig ?? chatNavigationBarConfig)
            .set(contactsViewConfig: self.contactsViewConfig)
            .set(firstQuestionConfig: self.firstQuestionConfig)
            .set(backgroundColor: self.viewControllerConfig.backgroundColor ?? sixthColor)
            .set(openFromNotification: self.openFromNotification ?? true)
            .set(infoCellConfig: self.infoCellConfig ?? infoCellConfig)
            .set(emptyChatTitle: self.emptyChatTitle ?? "")
            .set(loadMessagesTintColor: self.loadMessagesTintColor ?? fourthColor)
            .build()
        return chatConfig
    }
    
    private func imageViewControllerConfig() -> WMViewControllerConfig {
        let navigationConfig = WMImageNavigationBarConfigBuilder()
            .set(backgroundColorOnlineState: .clear)
            .set(backgroundColorOfflineState: .clear)
            .set(textColorOnlineState: thirdColor)
            .set(textColorOfflineState: thirdColor)
            .set(rightBarButtonImage: saveButtonImage)
            .build()
        
        let imageViewControllerConfig = WMImageViewControllerConfigBuilder()
            .set(saveViewColor: firstColor)
            .set(backgroundColor: .black)
            .set(navigationBarConfig: navigationConfig)
            .build()
        return imageViewControllerConfig
    }
    
    private func fileViewControllerConfig() -> WMViewControllerConfig {
        let navigationConfig = WMFileNavigationBarConfigBuilder()
            .set(backgroundColorOnlineState: thirdColor)
            .set(backgroundColorOfflineState: fifthColor)
            .set(textColorOnlineState: thirdColor)
            .set(textColorOfflineState: thirdColor)
            .set(rightBarButtonImage: fileShare)
            .build()
        
        let loadingFileTitle = NSAttributedString(
            string: "Loading File...".localized,
            attributes: [.font: UIFont.systemFont(ofSize: textSize + 1, weight: .regular),
                         .foregroundColor: UIColor.black,
                         .paragraphStyle: centerAligmentParagraphStyle])
        
        let fileViewControllerConfig = WMFileViewControllerConfigBuilder()
            .set(backgroundColor: .clear)
            .set(loadingLabelText: loadingFileTitle)
            .set(canShowLoadingIndicator: true)
            .set(navigationBarConfig: navigationConfig)
            .build()
        return fileViewControllerConfig
    }
    
    private func defaultPopupCellConfigBuilder() -> WMPopupActionCellConfigBuilder {
        let subtitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .natural
                return paragraphStyle
            }(),
            .font: UIFont.systemFont(ofSize: textSize + 1, weight: .regular),
            .foregroundColor: thirdColor
        ]
        let popupCellConfig = WMPopupActionCellConfigBuilder()
            .set(backgroundColor: .clear)
            .set(roundCorners: [])
            .set(cornerRadius: 0)
            .set(subtitleAttributes: subtitleAttributes)
            .set(strokeWidth: 0)
            .set(strokeColor: .clear)
        return popupCellConfig
    }
    
    private func defaultCosmosSettings() -> CosmosSettings {
        var settings = CosmosSettings()
        settings.fillMode = .full
        settings.starSize = 30
        settings.filledColor = firstColor
        settings.filledBorderColor = firstColor
        settings.emptyColor = fifthColor
        settings.emptyBorderColor = fifthColor
        settings.emptyBorderWidth = 2
        return settings
    }
}
