//
//  WMFirstQuestionViewConfigBuilder.swift
//  WebimMobileWidget
//
//  Created by Anna Frolova on 16.12.2024.
//

import Foundation
import UIKit

/**
 FirstQuestionView config.
 - author:
 Anna Frolova
 - copyright:
 2024 Webim
 */
public class WMFirstQuestionViewConfigBuilder: WMContactsViewConfigBuilder {
    
    private var uploadFileImage: UIImage?
    private var fileImage: UIImage?
    private var navigationTitleColor: UIColor?
    private var fileButtonColor: UIColor?
    private var titleBackgroundColor: UIColor?
    private var saveButtonInactiveTitleColor: UIColor?
    private var saveButtonTitleColor: UIColor?

    /**
     - returns:
     `WMContactsViewConfig` object.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public override func build() -> WMFirstQuestionViewConfig {
        let config = WMFirstQuestionViewConfig(contactsConfig: contactsConfig)
        config.uploadFileImage = uploadFileImage
        config.fileImage = fileImage
        config.navigationTitleColor = navigationTitleColor
        config.fileButtonColor = fileButtonColor
        config.titleBackgroundColor = titleBackgroundColor
        config.saveButtonInactiveTitleColor = saveButtonInactiveTitleColor
        config.saveButtonTitleColor = saveButtonTitleColor
        return config
    }

    /**
     Sets contacts view title.
     - parameter uploadFileImage:
     Title.
     - returns:
     `WMFirstQuestionViewConfig` object with contacts view title.
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(uploadFileImage: UIImage) -> Self {
        self.uploadFileImage = uploadFileImage
        return self
    }
    
    /**
     Sets contacts view title.
     - parameter title:
     Title.
     - returns:
     `WMFirstQuestionViewConfig` object with contacts view title.
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(fileImage: UIImage) -> Self {
        self.uploadFileImage = uploadFileImage
        return self
    }
    
    /**
     Sets contacts view title.
     - parameter navigationTitleColor:
     Title.
     - returns:
     `WMFirstQuestionViewConfig` object with contacts view title.
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(navigationTitleColor: UIColor) -> Self {
        self.navigationTitleColor = navigationTitleColor
        return self
    }
    
    /**
     Sets contacts view title.
     - parameter fileButtonColor:
     Title.
     - returns:
     `WMFirstQuestionViewConfig` object with contacts view title.
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(fileButtonColor: UIColor) -> Self {
        self.fileButtonColor = fileButtonColor
        return self
    }
    
    /**
     Sets contacts view title.
     - parameter titleBackgroundColor:
     Title.
     - returns:
     `WMFirstQuestionViewConfig` object with contacts view title.
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(titleBackgroundColor: UIColor) -> Self {
        self.titleBackgroundColor = titleBackgroundColor
        return self
    }
    
    /**
     Sets contacts view save button title color.
     - parameter saveButtonTitleColor:
     Title.
     - returns:
     `WMContactsViewConfig` object with contacts view save button title color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(saveButtonTitleColor: UIColor) -> Self {
        self.saveButtonTitleColor = saveButtonTitleColor
        return self
    }
    
    /**
     Sets contacts view save button inactive title color.
     - parameter saveButtonInactiveTitleColor:
     Title.
     - returns:
     `WMContactsViewConfig` object with contacts view save button inactive title color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(saveButtonInactiveTitleColor: UIColor) -> Self {
        self.saveButtonInactiveTitleColor = saveButtonInactiveTitleColor
        return self
    }
}
