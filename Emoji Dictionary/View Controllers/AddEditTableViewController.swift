//
//  AddEditViewController.swift
//  Emoji Dictionary
//
//  Created by Lore P on 16/02/2023.
//

import UIKit

// MARK: Delegate Protocol
protocol AddEditViewControllerDelegate: AnyObject {
    func finishPassing(emoji: Emoji)
}

class AddEditViewController: UIViewController {
    // MARK: Delegate property
    weak var delegate: AddEditViewControllerDelegate!
    
    

    public var emoji: Emoji?
    
    // MARK: Labels, TextFields and VStack
    private var spacing: UIView {
        
        let spacing = UIView()
        return spacing
    }
    
    private var symbolLabel: UILabel      = {
       
        let label       = UILabel()
        label.font      = .systemFont(ofSize: 12, weight: .regular)
        label.text      = "SYMBOL"
        label.textColor = .secondaryLabel
        
        return label
    }()
    private var nameLabel: UILabel        = {
       
        let label       = UILabel()
        label.font      = .systemFont(ofSize: 12, weight: .regular)
        label.text      = "NAME"
        label.textColor = .secondaryLabel
        
        return label
    }()
    private var descriptionLabel: UILabel = {
       
        let label       = UILabel()
        label.font      = .systemFont(ofSize: 12, weight: .regular)
        label.text      = "DESCRIPTION"
        label.textColor = .secondaryLabel
        
        return label
    }()
    private var usageLabel: UILabel       = {
       
        let label       = UILabel()
        label.font      = .systemFont(ofSize: 12, weight: .regular)
        label.text      = "USAGE"
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    public var symbolTextField: UITextField      = {
       
        let textField             = UITextField()
        textField.borderStyle     = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        
        return textField
    }()
    public var nameTextField: UITextField        = {
       
        let textField             = UITextField()
        textField.borderStyle     = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        
        return textField
    }()
    public var descriptionTextField: UITextField = {
       
        let textField             = UITextField()
        textField.borderStyle     = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        
        return textField
    }()
    public var usageTextField: UITextField       = {
       
        let textField             = UITextField()
        textField.borderStyle     = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        
        return textField
    }()
    
    private var stackView = UIStackView()
    
    
    // MARK: Save button
    var saveButton = UIBarButtonItem(
        barButtonSystemItem: .save,
        target: AddEditViewController.self,
        action: #selector(saveButtonPressed)
    )
    
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        view.addSubview(stackView)
        configureStackView()
        
        // State of the Save Button
        configureTextFields()
        updateSaveButtonState()
    }
    
    override func viewDidLayoutSubviews() {
        updateSaveButtonState()
    }
    

    // MARK: Cancel, Save, Editing TxtFs
    @objc func didTapCancel() {
        dismiss(animated: true)
    }
    @objc func editingChanged() {
        updateSaveButtonState()
    }
    @objc func saveButtonPressed() {
        let symbolText      = symbolTextField.text!
        let nameText        = nameTextField.text!
        let descriptionText = descriptionTextField.text!
        let usageText       = usageTextField.text!
        
        let emoji           = Emoji(symbol: symbolText, name: nameText, description: descriptionText, usage: usageText)
        
        // MARK: Delegate call
        // Delegate method defined in Receiver View Controller
        // which will use emoji to set its own properties
        delegate.finishPassing(emoji: emoji)

        dismiss(animated: true)
    }
    
    
    
    
    // MARK: Update state of the Save Button
    // Editing TxtFs
    private func configureTextFields() {
        
        symbolTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        descriptionTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        usageTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    // Check isEmoji
    private func containsSingleEmoji(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text,
              text.count == 1 else {
            return false
        }
        
        let isCombinedIntoEmoji = text.unicodeScalars.count > 1 && text.unicodeScalars.first?.properties.isEmoji ?? false
        let isEmojiPresentation = text.unicodeScalars.first?.properties.isEmojiPresentation ?? false
        
        return isCombinedIntoEmoji || isEmojiPresentation
    }
    
    private func updateSaveButtonState() {
        
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        let usageText = usageTextField.text ?? ""
        
        saveButton.isEnabled =
        containsSingleEmoji(symbolTextField) &&
        !nameText.isEmpty &&
        !descriptionText.isEmpty &&
        !usageText.isEmpty
    }
}


extension AddEditViewController {
    // MARK: UI Configuration
    private func configureNavigationBar() {
        
        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = saveButton
        navigationController?.navigationBar.tintColor = .systemTeal
        
        
        // THIS NEXT LINE DID ALL THE HEAVY LIFTING
        // the Save button would not work if presented the VC from didSelectRowAt, just one little spell
        saveButton.target = self
        
    }

    private func configureStackView() {
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(symbolLabel)
        stackView.addArrangedSubview(symbolTextField)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameTextField)
        
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(descriptionTextField)
        
        stackView.addArrangedSubview(usageLabel)
        stackView.addArrangedSubview(usageTextField)
        
        symbolTextField.text = emoji?.symbol ?? ""
        nameTextField.text = emoji?.name ?? ""
        descriptionTextField.text = emoji?.description ?? ""
        usageTextField.text = emoji?.usage ?? ""
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewContraints = [
            stackView.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.topAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.83)
        ]
        
        
        NSLayoutConstraint.activate(stackViewContraints)
    }
}
