//
//  FirstQuestionViewController.swift
//  WebimMobileWidget
//
//  Created by Anna Frolova on 16.12.2024.
//

import WebimMobileSDK
import Foundation
import UIKit

protocol FirstQuestionControllerDelegate: AnyObject {
    func firstQuestionSave(message: String,
                           visitorFields: String?,
                           viewType: ViewType,
                           file: Data?,
                           fileName: String?,
                           mimeType: String?)
    
    func firstQuestionClosed()
}

enum ViewType {
    case firstQuestion
    case offlineMode
    case contacts
}

class FirstQuestionViewController: UIViewController {
    
    lazy var filePicker = FilePicker(presentationController: self, delegate: self)
    
    weak var delegate: FirstQuestionControllerDelegate?
    
    var webimServerSideSettingsManager: WebimServerSideSettingsManager?
    var config: WMFirstQuestionViewConfig?
    var viewType: ViewType = .firstQuestion
    
    private var contactsSettings: [(key: String, value: Contact)]? = []
    private var contactsLables: [String: String?]? = [:]
    private var visitorInfo: [String: String]? = [:]
    private var selectedCellHeight: CGFloat = 40.0
    private var selectedFileMimeType: String?
    private var selectedFile: Data?
    private var mandatoryFields: [String] = []
    private let messageLabel = "Message".localized
    private var fields: [String] =  ["name",
                                     "phone",
                                     "email",
                                     "first_custom_field",
                                     "second_custom_field",
                                     "third_custom_field",
                                     "message"]
    
    //Message textView colors
    private var textColor: UIColor?
    private var inactiveTextColor: UIColor?
    private var inactiveBackgroundColor: UIColor?
    private var activeBackgroundColor: UIColor?
    private var labelColor: UIColor?
    private var activeLayerColor: UIColor = contactsCellActiveLayerColor
    private var inactiveLayerColor: UIColor = contactsCellInactiveLayerColor
    private var saveButtonActiveColor: UIColor = firstQuestionActiveSaveButtonColor
    private var saveButtonInactiveColor: UIColor = firstQuestionInactiveSaveButtonColor
    private var saveButtonActiveTitleColor: UIColor = firstQuestionSaveButtonTextColor
    private var saveButtonInactiveTitleColor: UIColor = firstQuestionSaveButtonInactiveTextColor
    private var navigationTitleColor: UIColor = contactsNavigationTitleColor
    private var agreementTextColor: UIColor = firstQuestionAgreementTextColor
    private var agreementLinkColor: UIColor = firstQuestionAgreementLinkColor
    
    private var titleLabelColor: UIColor = firstQuestionNavigationTitleColor {
        didSet {
            titleLabel.textColor = titleLabelColor
        }
    }
    
    private var titleBackgroundColor: UIColor = firstQuestionTitleBackgroundColor {
        didSet {
            titleView.backgroundColor = titleBackgroundColor
        }
    }
    
    private var selectedFileName: String? {
        didSet {
            fileName.text = selectedFileName
            fileStatusImage.setImage(fileDownloadSuccessImage, for: .normal)
        }
    }
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var agreementCheckmark: CheckboxButton!
    @IBOutlet weak var agreementText: UITextView!
    @IBOutlet weak var addFileButton: UIButton!
    @IBOutlet weak var fileView: UIView!
    @IBOutlet weak var fileStatusImage: UIButton!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    @IBOutlet weak var agreementView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messagePlaceholder: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
        setupHideKeyboardGesture()
        setupConfig()
        setupMessageView()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupViewData()
        if webimServerSideSettingsManager?.showProcessingPersonalDataCheckbox() != false {
            setupAgreement()
        }
        visitorInfo = WebimServiceController.currentSession.getVisitor()?.getVisitorFieldsInDictionary()
        contactsLables = webimServerSideSettingsManager?.getVisiorFieldsLables()
        setZeroInsets()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewHeight()
    }
    
    @objc
    func closeViewController() {
        self.popViewController()
        self.delegate?.firstQuestionClosed()
    }
    
    @IBAction func sendOrContinue(_ sender: Any) {
        if let visitor = visitorInfo, let jsonData = try? JSONSerialization.data(withJSONObject: visitor, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            delegate?.firstQuestionSave(message: messageTextView.text,
                                        visitorFields: jsonString,
                                        viewType: viewType,
                                        file: selectedFile,
                                        fileName: selectedFileName,
                                        mimeType: selectedFileMimeType)
        } else if let firstQuestion = messageTextView.text {
            delegate?.firstQuestionSave(message: firstQuestion,
                                        visitorFields: nil,
                                        viewType: viewType,
                                        file: selectedFile,
                                        fileName: selectedFileName,
                                        mimeType: selectedFileMimeType)
        }
        self.popViewController()
    }
    
    func setupConfig() {
        
        navigationTitleColor = config?.navigationTitleColor ?? contactsNavigationTitleColor
        
        titleBackgroundColor = config?.titleBackgroundColor ?? firstQuestionTitleBackgroundColor
        
        textColor = config?.cellNameColor ?? contactsCellActiveTextColor
        
        if let titleLabelText = config?.title {
            titleLabel.attributedText = titleLabelText
        }
        
        if let saveButtonColor = config?.saveButtonColor {
            saveButtonActiveColor = saveButtonColor
        }
        
        if let saveButtonColor = config?.inactiveSaveButtonColor {
            saveButtonInactiveColor = saveButtonColor
        }
        
        if let saveButtonTextColor = config?.saveButtonTitleColor {
            saveButtonActiveTitleColor = saveButtonTextColor
        }
        
        if let saveButtonTextColor = config?.saveButtonInactiveTitleColor {
            saveButtonInactiveTitleColor = saveButtonTextColor
        }
        
        if let backgroundColor = config?.backgroundColor {
            collectionView.backgroundColor = backgroundColor
        }
        
        if let closeButtonImage = config?.closeButtonImage {
            navigationItem.leftBarButtonItem?.image = closeButtonImage
        }
        
        if let agreementTextColor = config?.agreementTextColor {
            self.agreementTextColor = agreementTextColor
        }
        
        if let agreementLinkColor = config?.agreementLinkColor {
            self.agreementLinkColor = agreementLinkColor
        }
    }
    
    func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let height = collectionView.contentSize.height
        collectionViewHeightConstraint.constant = height
        view.layoutIfNeeded()
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
    

    @IBAction func showSendFileMenu(_ sender: UIButton) {
        filePicker.showSendFileMenu(from: sender)
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
    
    private func setupViewData() {
        var visitorFields: [String: Contact] = [:]
        var labelText = ""
        if viewType == .firstQuestion {
            visitorFields = webimServerSideSettingsManager?.getVisiorFieldsSettings()?.getFirstQuestionVsDef() ?? [:]
            labelText = webimServerSideSettingsManager?.getResources()?.getFirstQuestionMessage() ?? "First message label".localized
        } else {
            visitorFields = webimServerSideSettingsManager?.getVisiorFieldsSettings()?.getOfflineModeVsDef() ?? [:]
            labelText = webimServerSideSettingsManager?.getResources()?.getLeaveMessage() ?? "Offline message label".localized
        }
        titleLabel.text = labelText
        let contacts = Array(visitorFields.filter { $0.value.getPresence() != Presence.none })
        contactsSettings = contacts.sorted { (first, second) -> Bool in
            guard let firstIndex = fields.firstIndex(of: first.key),
                  let secondIndex = fields.firstIndex(of: second.key) else {
                return false
            }
            return firstIndex < secondIndex
        }
        mandatoryFields = contactsSettings?.compactMap { (key, value) in
            value.getPresence() == .mandatory ? key : nil
        } ?? []
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
                                                                    linkColor: agreementLinkColor)
        agreementText.attributedText = attributedString
        agreementText.isEditable = false
        agreementView.isHidden = false
    }
    
    @IBAction func tapCheckmark(_ sender: Any) {
        checkSaveButtonEnabled()
    }
    
    func checkSaveButtonEnabled() {
        if !messageTextView.text.isEmpty && messageTextView.text != ("Message".localized) {
            let isChecked = webimServerSideSettingsManager?.showProcessingPersonalDataCheckbox() != false ? (agreementCheckmark.buttonState == .checked && checkEmptyFields()) : checkEmptyFields()
            saveButton.isEnabled = isChecked
            saveButton.backgroundColor = isChecked ? saveButtonActiveColor : saveButtonInactiveColor
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = saveButtonInactiveColor
        }
    }
    
    func setupView() {
        let navigationTitleLabel = UILabel()
        navigationTitleLabel.text = viewType == .firstQuestion ? "Live chat agent".localized : "Offline request".localized
        navigationTitleLabel.textColor = navigationTitleColor
        self.navigationItem.titleView = navigationTitleLabel
        saveButton.setTitle("Continue".localized, for: .normal)
        saveButton.setTitleColor(saveButtonActiveTitleColor, for: .normal)
        saveButton.setTitle("Continue".localized, for: .disabled)
        saveButton.setTitleColor(saveButtonInactiveTitleColor, for: .disabled)
        saveButton.backgroundColor = saveButtonInactiveColor
        saveButton.layer.cornerRadius = 20
        fileStatusImage.setImage(fileDownloadButtonImage, for: .normal)
        let buttonTitle = "  " + "Attach file".localized
        addFileButton.setTitle(buttonTitle, for: .normal)
        if viewType == .offlineMode {
            setupFileView(isFileSelected: false)
        }
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(closeViewController)
        )
        self.navigationItem.leftBarButtonItem = button
    }
    
    func setupMessageView() {
        activeBackgroundColor = config?.cellBackgroundColor ?? contactsCellBackgroundTextColor
        inactiveBackgroundColor = config?.cellInactiveBackgroundColor ?? contactsCellInactiveBackgroundColor
        labelColor = config?.cellLabelColor ?? contactsCellLabelColor
        inactiveTextColor = config?.cellInactiveColor ?? contactsCellInactiveTextColor
        messageTextView.layer.cornerRadius = 6
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.borderColor = inactiveLayerColor.cgColor
        messageTextView.smartQuotesType = .no
        messageTextView.smartDashesType = .no
        messageTextView.smartInsertDeleteType = .no
        messageTextView.autocorrectionType = .no
        messageTextView.spellCheckingType = .no
        messageTextView.isScrollEnabled = false
        messageTextView.isEditable = true
        messageTextView.textContainer.maximumNumberOfLines = 1
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset.left = 16
        messageTextView.textContainerInset.right = 16
        messageTextView.text = messageLabel
        messagePlaceholder.text = messageLabel
        messageTextView.delegate = self
        messageTextView.textColor = inactiveTextColor
        messagePlaceholder.isHidden = true
        messageTextView.textContainerInset.top = 12
    }
    
    func checkEmptyFields() -> Bool {
        return mandatoryFields.allSatisfy { contact in
            !(visitorInfo?[contact] ?? "").isEmpty
        }
    }
}

extension FirstQuestionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        cell.setupConfig(firstQuestionConfig: config)
        cell.setup(info: visitorField, name: contactSettings?.key ?? "", data: contactSettings?.value, label: label, viewType: viewType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
}

extension FirstQuestionViewController: VisitorFieldsCellDelegate {
    
    func setField(name: String, field: String?) {
        visitorInfo?[name] = field ?? ""
        checkSaveButtonEnabled()
    }
    
    func selectCell(_ height: CGFloat) {
        selectedCellHeight = height
    }
    
}

extension FirstQuestionViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkTextEmpty(checkText: true)
        checkSaveButtonEnabled()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        messageTextView.layer.borderColor = inactiveLayerColor.cgColor
        messagePlaceholder.textColor = labelColor
        checkTextEmpty(endEditing: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        messagePlaceholder.textColor = textColor
        messageTextView.layer.borderColor = activeLayerColor.cgColor
        checkTextEmpty(checkText: true)
    }
    
    func checkTextEmpty(checkText: Bool = false, endEditing: Bool = false) {
        if messageTextView.text.isEmpty {
            messageTextView.textColor = inactiveTextColor
            messagePlaceholder.isHidden = !checkText
            messageTextView.textContainerInset.top = checkText ? 21 : 13
            messageTextView.text = checkText ? messageTextView.text : messageLabel
        } else {
            if checkText && messageTextView.text == messageLabel {
                messageTextView.text = ""
                messageTextView.textColor = inactiveTextColor
                messagePlaceholder.isHidden = endEditing
                messageTextView.textContainerInset.top = endEditing ? 13 : 21
            } else {
                messagePlaceholder.isHidden = false
                messageTextView.textColor = textColor
                messageTextView.textContainerInset.top = 21
            }
        }
    }
}


extension FirstQuestionViewController: ServerSideSettingsCompletionHandler {
    
    func onFailure() {
    }
    
    func onSuccess(webimServerSideSettings: ServerSettings) {
        setupViewData()
    }
    
}

extension FirstQuestionViewController: FilePickerDelegate {

    func didSelect(images: [ImageToSend]) {
        guard let image = images.first, let imageToSend = image.image else { return }
        var imageData = Data()
        let imageURL = image.url
        var imageName = String()
        var mimeType = MimeType()
            
        if let imageURL = imageURL {
            mimeType = MimeType(url: imageURL as URL)
            imageName = imageURL.lastPathComponent
                
            let imageExtension = imageURL.pathExtension.lowercased()
                
            switch imageExtension {
            case "jpg", "jpeg":
                guard let unwrappedData = imageToSend.jpegData(compressionQuality: 1.0) else { return }
                imageData = unwrappedData
                    
            case "heic", "heif":
                guard let unwrappedData = imageToSend.jpegData(compressionQuality: 0.5) else { return }
                imageData = unwrappedData
                    
                var components = imageName.components(separatedBy: ".")
                if components.count > 1 {
                    components.removeLast()
                    imageName = components.joined(separator: ".")
                }
                imageName += ".jpeg"
                    
            default:
                guard let unwrappedData = imageToSend.pngData()
                else { return }
                imageData = unwrappedData
            }
        } else {
            guard let unwrappedData = imageToSend.jpegData(compressionQuality: 1.0)
            else { return }
            imageData = unwrappedData
            imageName = "photo.jpeg"
        }
        self.selectedFile = imageData
        self.selectedFileName = imageName
        self.selectedFileMimeType = mimeType.value
        setupFileView(isFileSelected: true)
    }

    func didSelect(files: [FileToSend]) {
        guard let file = files.first else { return }
        let fileURL = file.url ?? URL(fileURLWithPath: "document.pdf")
        self.selectedFileName = fileURL.lastPathComponent
        self.selectedFile = file.file
        self.selectedFileMimeType = MimeType(url: fileURL).value
        setupFileView(isFileSelected: true)
    }
    
    func setupFileView(isFileSelected: Bool) {
        fileView.isHidden = !isFileSelected
        addFileButton.isHidden = isFileSelected
    }
}
