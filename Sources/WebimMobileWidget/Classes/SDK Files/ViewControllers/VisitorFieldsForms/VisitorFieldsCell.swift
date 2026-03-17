//
//  ContactsTableViewCell.swift
//  WebimMobileWidget
//
//  Created by Anna Frolova on 20.09.2024.
//

import UIKit
import WebimMobileSDK

protocol VisitorFieldsCellDelegate: AnyObject {
    func setField(name: String, field: String?)
    func selectCell(_ height: CGFloat)
}

class VisitorFieldsCell: UICollectionViewCell {
    
    weak var delegate: VisitorFieldsCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    private var fieldSettings: Contact?
    private var name: String = ""
    private var label: String? = ""
    private var viewType: ViewType?
    
    private var textColor: UIColor?
    private var errorColor: UIColor?
    private var inactiveColor: UIColor?
    private var inactiveBackgroundColor: UIColor?
    private var activeBackgroundColor: UIColor?
    private var inactiveLayerColor: CGColor?
    private var activeLayerColor: CGColor?
    private var labelColor: UIColor?
    
    
    func setup(info: String?,
               name: String,
               data: Contact?,
               label: String? = "",
               viewType: ViewType) {
        self.label = label ?? ""
        self.name = name
        nameLabel.text = self.label
        if data?.getPresence() == .optional {
            self.label? += (" " + "Optional".localized)
        }
        self.fieldSettings = data
        self.viewType = viewType
        textView.layer.cornerRadius = 6
        textView.layer.borderWidth = 1
        textView.layer.borderColor = inactiveLayerColor
        textView.delegate = self
        textView.text = info
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.smartInsertDeleteType = .no
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.isScrollEnabled = false
        textView.textContainer.maximumNumberOfLines = 1
        textView.textContainer.lineFragmentPadding = 0
        setupField()
        checkTextEmpty(endEditing: true)
        textView.textContainerInset.left = 16
        textView.textContainerInset.right = 16
    }
    
    func setupField() {
        let presence = fieldSettings?.getPresence()
        switch presence {
        case .mandatory:
            textView.isSelectable = true
            textView.isEditable = true
            textView.backgroundColor = activeBackgroundColor
        case .optional:
            textView.isSelectable = true
            textView.isEditable = true
            textView.backgroundColor = activeBackgroundColor
        default:
            break
        }
    }
    
    func setupConfig(config: WMContactsViewConfig?) {
        labelColor = config?.cellLabelColor ?? contactsCellLabelColor
        nameLabel.textColor = labelColor
        textColor = config?.cellNameColor ?? contactsCellActiveTextColor
        textView.textColor = textColor
        inactiveColor = config?.cellInactiveColor ?? contactsCellInactiveTextColor
        errorColor = config?.cellErrorColor ?? contactsCellTextErrorColor
        activeBackgroundColor = config?.cellBackgroundColor ?? contactsCellBackgroundTextColor
        inactiveBackgroundColor = config?.cellInactiveBackgroundColor ?? contactsCellInactiveBackgroundColor
        inactiveLayerColor = config?.cellInactiveLayerColor?.cgColor ?? contactsCellInactiveLayerColor.cgColor
        activeLayerColor = config?.cellActiveLayerColor?.cgColor ?? contactsCellActiveLayerColor.cgColor
        if let cellLabelFont = config?.cellLabelFont {
            nameLabel.font = cellLabelFont
        }
        
        if let cellNameFont = config?.cellNameFont {
            textView.font = cellNameFont
        }
    }
    
    func setupConfig(firstQuestionConfig: WMFirstQuestionViewConfig?) {
        setupConfig(config: firstQuestionConfig)
    }
    
}

extension VisitorFieldsCell : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.setField(name: name, field: textView.text)
        checkTextEmpty(checkText: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = activeBackgroundColor?.cgColor
        nameLabel.textColor = labelColor
        checkTextEmpty(endEditing: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.delegate?.selectCell(contentView.frame.height)
        nameLabel.textColor = textColor
        textView.layer.borderColor = textColor?.cgColor
        
        checkTextEmpty(checkText: true)
    }
    
    func checkTextEmpty(checkText: Bool = false,
                        endEditing: Bool = false) {
        if textView.text.isEmpty {
            textView.textColor = inactiveColor
            nameLabel.isHidden = !checkText
            textView.textContainerInset.top = checkText ? 21 : 13
            textView.text = checkText ? textView.text : label
        } else {
            if checkText && textView.text == label {
                textView.text = ""
                nameLabel.isHidden = endEditing
                textView.textContainerInset.top = endEditing ? 13 : 21
            } else {
                nameLabel.isHidden = false
                textView.textContainerInset.top = 21
            }
            textView.textColor = fieldSettings?.getValidation()?.getMaxLength() ?? (textView.text.count + 1) > textView.text.count ? ((endEditing && textView.text == self.label) ? inactiveColor : textColor) : errorColor
        }
    }
}
