//
//  AgreementText.swift
//  WebimMobileWidget
//
//  Created by Anna Frolova on 30.12.2025.
//
import Foundation
import UIKit

class AgreementText {
    let part1: String = "agreement_part1".localized
    let part2: String = "agreement_part2".localized
    let part3: String = "agreement_part3".localized
    let part4: String = "agreement_part4".localized
    
    private func getFullText() -> String {
        let locale = Locale.current.identifier
        switch locale.prefix(2) {
        case "ar", "he":
            return "\(part4) \(part3) \(part2) \(part1)"
        case "ja", "ko":
            return "\(part1)\(part2)\(part3)\(part4)"
        default:
            return "\(part1) \(part2) \(part3) \(part4)"
        }
    }
    
    func getTextWithHyperlink(personalDataURL: String,
                              privacyPolicyURL: String,
                              textColor: UIColor,
                              linkColor: UIColor) -> NSAttributedString {
        let fullText = getFullText()
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor,
                                      value: textColor,
                                      range: NSRange(location: 0, length: fullText.count))
        let range2 = (fullText as NSString).range(of: part2)
        if range2.location != NSNotFound {
            attributedString.addAttribute(.link, value: personalDataURL, range: range2)
            attributedString.addAttribute(.foregroundColor, value: linkColor, range: range2)
        }
    
        let range4 = (fullText as NSString).range(of: part4)
        if range4.location != NSNotFound {
            attributedString.addAttribute(.link, value: privacyPolicyURL, range: range4)
            attributedString.addAttribute(.foregroundColor, value: linkColor, range: range4)
        }
        
        attributedString.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: 12),
                                    range: NSRange(location: 0, length: fullText.count))
        
        return attributedString
    }
}
