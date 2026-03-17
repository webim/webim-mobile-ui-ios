//
//  Untitled.swift
//  WebimMobileWidget
//
//  Created by Anna Frolova on 20.09.2024.
//

import WebimMobileSDK
import UIKit

protocol ContactsViewControllerDelegate: AnyObject {
    func sendContactsAnswer(_ contacts: String)
}

class ContactsViewController: UIViewController {
    
    weak var delegate: ContactsViewControllerDelegate?
    
    @IBOutlet weak var contactsViewTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var transparentBackgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var agreementCheckmark: CheckboxButton!
    @IBOutlet weak var agreementText: UITextView!
    @IBOutlet weak var agreementView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var selectedCellHeight: CGFloat = 40.0
    private var agreementTextColor: UIColor = contactsAgreementTextColor
    private var agreementLinkColor: UIColor = contactsAgreementLinkColor
    
    private var mandatoryFields: [String] = []
    private var fields: [String] =
        ["name",
         "phone",
         "email",
         "first_custom_field",
         "second_custom_field",
         "third_custom_field"]
    
    var webimServerSideSettingsManager: WebimServerSideSettingsManager?
    var visitorInfo: [String: String]?
    var config: WMContactsViewConfig?
    
    private var contactsSettings: [(key: String, value: Contact)]? = []
    private var contactsLables: [String: String?]? = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
        setupHideKeyboardGesture()
        setupConfig()
        collectionView.dataSource = self
        collectionView.delegate = self
        scrollView.layer.cornerRadius = 12
        saveButton.isEnabled = false
        setupNavigationBar()
        if let visitorFields = webimServerSideSettingsManager?.getVisiorFieldsSettings()?.getContactsRequestVsDef() {
            let contacts = Array(visitorFields.filter { $0.value.getPresence() != Presence.none })
            contactsSettings = contacts.sorted { (first, second) -> Bool in
                guard let firstIndex = fields.firstIndex(of: first.key),
                      let secondIndex = fields.firstIndex(of: second.key) else {
                    return false
                }
                return firstIndex < secondIndex
            }
        }
        contactsLables = webimServerSideSettingsManager?.getVisiorFieldsLables()
        if webimServerSideSettingsManager?.showProcessingPersonalDataCheckbox() != false {
            setupAgreement()
        }
        let touch = UITapGestureRecognizer(target: self, action: #selector(closeViewController))
        setZeroInsets()
        mandatoryFields = contactsSettings?.compactMap { (key, value) in
            value.getPresence() == .mandatory ? key : nil
        } ?? []
        checkSaveButtonEnabled()
        self.transparentBackgroundView?.addGestureRecognizer(touch)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
    }
    
    @objc
    func closeViewController() {
        self.transparentBackgroundView?.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        closeViewController()
    }
    
    @IBAction func sendOrContinue(_ sender: Any) {
        if let visitor = visitorInfo, let jsonData = try? JSONSerialization.data(withJSONObject: visitor, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            delegate?.sendContactsAnswer(jsonString)
        }
        closeViewController()
    }
    
    func setupConfig() {
        
        saveButton.title = config?.saveButtonTitle ?? "Save".localized
        
        contactsViewTitle.attributedText = config?.title ?? NSAttributedString(string: "Contact information".localized)
        
        if let title = config?.title {
            contactsViewTitle.attributedText = title
        }
        
        if let saveButtonColor = config?.saveButtonColor {
            saveButton.tintColor = saveButtonColor
        }
        
        if let backgroundColor = config?.backgroundColor {
            collectionView.backgroundColor = backgroundColor
        }
        
        if let closeButtonImage = config?.closeButtonImage {
            backButton.image = closeButtonImage
        }
        
        if let agreementTextColor = config?.agreementTextColor {
            self.agreementTextColor = agreementTextColor
        }
        
        if let agreementLinkColor = config?.agreementLinkColor {
            self.agreementLinkColor = agreementLinkColor
        }
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear

        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
    
    deinit {
        unobserveKeyboardNotifications()
    }

    @objc
    func keyboardWillShow(_ notification: Notification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.bounds.height < self.view.bounds.width {
                collectionView.contentInset = UIEdgeInsets(top: 0,
                                                           left: 0,
                                                           bottom: keyboardSize.height + selectedCellHeight,
                                                           right: 0)
            }
        }
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {

        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            setZeroInsets()
        }
    }

    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func tapCheckmark(_ sender: Any) {
        checkSaveButtonEnabled()
    }
    
    private func checkSaveButtonEnabled() {
       saveButton.isEnabled = webimServerSideSettingsManager?.showProcessingPersonalDataCheckbox() != false ? (agreementCheckmark.buttonState == .checked && checkEmptyFields()) : checkEmptyFields()
    }
    
    private func setZeroInsets() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func setupHideKeyboardGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func unobserveKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
            
        guard let columnLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        columnLayout.invalidateLayout()
        setZeroInsets()
    }
    
    private func setupAgreement() {
        let personalDataURL = webimServerSideSettingsManager?.getProcessingPersonalDataUrl() ?? "https://webim.ru/doc/agreement/"
        let privacyPolicyURL = webimServerSideSettingsManager?.getPrivacyPolicyUrl() ?? "https://webim.ru/doc/privacy/"
        let attributedString = AgreementText().getTextWithHyperlink(personalDataURL: personalDataURL,
                                                                    privacyPolicyURL: privacyPolicyURL,
                                                                    textColor: agreementTextColor,
                                                                    linkColor: contactsAgreementLinkColor)
        agreementText.attributedText = attributedString
        agreementView.isHidden = false
    }
    
    func checkEmptyFields() -> Bool {
        return mandatoryFields.allSatisfy { contact in
            !(visitorInfo?[contact] ?? "").isEmpty
        }
    }
    
}

extension ContactsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contactsSettings?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithType(VisitorFieldsCell.self,
                                                                   for: indexPath)
        
        let index = indexPath.row
        var visitorField: String?
        let contactSettings = contactsSettings?[index]
        var contactLabel: String?
        if let contact = contactSettings {
            contactLabel = contactsLables?.first(where: { $0.key == contact.key })?.value
            visitorField = visitorInfo?[contact.key] ?? ""
        }
       
        let label = contactLabel ?? contactSettings?.key.localized
        cell.delegate = self
        cell.setupConfig(config: config)
        cell.setup(info: visitorField, name: contactSettings?.key ?? "", data: contactSettings?.value, label: label, viewType: .contacts)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
}

extension ContactsViewController: VisitorFieldsCellDelegate {
    
    func setField(name: String, field: String?) {
        visitorInfo?[name] = field ?? ""
        checkSaveButtonEnabled()
    }
    
    func selectCell(_ height: CGFloat) {
        selectedCellHeight = height
    }
}
