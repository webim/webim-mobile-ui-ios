//
//  WMContactsViewConfigBuilder.swift
//  Pods
//
//  Created by Anna Frolova on 02.12.2024.
//

import Foundation
import UIKit

/**
 ContactsView config.
 - author:
 Anna Frolova
 - copyright:
 2024 Webim
 */
public class WMContactsViewConfigBuilder {
    var contactsConfig = WMContactsViewConfig()

    public init() { }

    /**
     - returns:
     `WMContactsViewConfig` object.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func build() -> WMContactsViewConfig {
        return contactsConfig
    }

    /**
     Sets contacts view title.
     - parameter title:
     Title.
     - returns:
     `WMContactsViewConfig` object with contacts view title.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(title: NSAttributedString) -> Self {
        contactsConfig.title = title
        return self
    }

    /**
     Sets contacts view save button title.
     - parameter saveButtonTitle:
     Title.
     - returns:
     `WMContactsViewConfig` object with contacts view save button title.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(saveButtonTitle: String) -> Self {
        contactsConfig.saveButtonTitle = saveButtonTitle
        return self
    }
    
    /**
     Sets contacts view save button color.
     - parameter saveButtonColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view save button color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(saveButtonColor: UIColor) -> Self {
        contactsConfig.saveButtonColor = saveButtonColor
        return self
    }
    
    /**
     Sets contacts view inactive save button color.
     - parameter inactiveSaveButtonColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view inactive save button color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(inactiveSaveButtonColor: UIColor) -> Self {
        contactsConfig.inactiveSaveButtonColor = inactiveSaveButtonColor
        return self
    }
    
    /**
     Sets contacts view background color.
     - parameter backgroundColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view background color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(backgroundColor: UIColor) -> Self {
        contactsConfig.backgroundColor = backgroundColor
        return self
    }
    
    /**
     Sets contacts view close button image.
     - parameter closeButtonImage:
     Image.
     - returns:
     `WMContactsViewConfig` object with contacts view close button image.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(closeButtonImage: UIImage) -> Self {
        contactsConfig.closeButtonImage = closeButtonImage
        return self
    }
    
    /**
     Sets contacts view cell label color.
     - parameter cellLabelColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view cell label color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(cellLabelColor: UIColor) -> Self {
        contactsConfig.cellLabelColor = cellLabelColor
        return self
    }
    
    /**
     Sets contacts view cell label font.
     - parameter cellLabelFont:
     Font.
     - returns:
     `WMContactsViewConfig` object with contacts view cell label font.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(cellLabelFont: UIFont) -> Self {
        contactsConfig.cellLabelFont = cellLabelFont
        return self
    }
    
    /**
     Sets contacts view cell name color.
     - parameter cellNameColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view cell name color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(cellNameColor: UIColor) -> Self {
        contactsConfig.cellNameColor = cellNameColor
        return self
    }
    
    /**
     Sets contacts view cell name font.
     - parameter cellNameFont:
     Font.
     - returns:
     `WMContactsViewConfig` object with contacts view cell name font.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(cellNameFont: UIFont) -> Self {
        contactsConfig.cellNameFont = cellNameFont
        return self
    }
    
    /**
     Sets contacts view cell error color.
     - parameter cellErrorColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view cell error color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(cellErrorColor: UIColor) -> Self {
        contactsConfig.cellErrorColor = cellErrorColor
        return self
    }
    
    /**
     Sets contacts view cell inactive color.
     - parameter cellInactiveColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view cell inactive color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(cellInactiveColor: UIColor) -> Self {
        contactsConfig.cellInactiveColor = cellInactiveColor
        return self
    }
    
    /**
     Sets contacts view cell background color.
     - parameter cellBackgroundColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view cell background color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(cellBackgroundColor: UIColor) -> Self {
        contactsConfig.cellBackgroundColor = cellBackgroundColor
        return self
    }
    
    /**
     Sets contacts view inactive cell background color.
     - parameter cellInactiveBackgroundColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view inactive cell background color.
     Anna Frolova
     - copyright:
     2024 Webim
     */
    public func set(cellInactiveBackgroundColor: UIColor) -> Self {
        contactsConfig.cellInactiveBackgroundColor = cellInactiveBackgroundColor
        return self
    }
    
    /**
     Sets contacts view cell active layer color.
     - parameter cellActiveLayerColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view cell active layer color.
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(cellActiveLayerColor: UIColor) -> Self {
        contactsConfig.cellActiveLayerColor = cellActiveLayerColor
        return self
    }
    
    /**
     Sets contacts view inactive cell layer color.
     - parameter cellInactiveBackgroundColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view inactive cell layer color.
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(cellInactiveLayerColor: UIColor) -> Self {
        contactsConfig.cellInactiveLayerColor = cellInactiveLayerColor
        return self
    }
    
    /**
     Sets contacts view agreement text color.
     - parameter agreementTextColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view agreement text color..
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(agreementTextColor: UIColor) -> Self {
        contactsConfig.agreementTextColor = agreementTextColor
        return self
    }
    
    /**
     Sets contacts view agreement link color.
     - parameter agreementLinkColor:
     Color.
     - returns:
     `WMContactsViewConfig` object with contacts view agreement link color.
     Anna Frolova
     - copyright:
     2025 Webim
     */
    public func set(agreementLinkColor: UIColor) -> Self {
        contactsConfig.agreementLinkColor = agreementLinkColor
        return self
    }
    
}
