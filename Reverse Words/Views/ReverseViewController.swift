//
//  ViewController.swift
//  Reverse Words
//
//  Created by Igor Plastun on 21.10.2024.
//

import UIKit

final class ReverseViewController: UIViewController {
    enum ReverseState{
        case initial
        case typing
        case result
    }
    
    var state: ReverseState = .initial {
        didSet {
            changeState()
        }
    }
    
    private var reversedString = ""
    private var isReversed: Bool = false
    private var bottomButtonConstraint: NSLayoutConstraint?
    private var service: ReverseManager = ReverseManager()
    //MARK: ui elements
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Reverse Words"
        label.font = .systemFont(ofSize: .init(32), weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "The application will reverse your words. Please type text below"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = .systemFont(ofSize: .init(15))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var reverseTextField: UITextField = {
        var field = UITextField()
        field.placeholder = "Text to reverse"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private var dividerView: UIView = {
        var view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Default", "Custom"])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        segment.selectedSegmentTintColor = .systemBlue
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        return segment
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "All characters except alphabetic symbols"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var textToIngoreTextField: UITextField = {
        var field = UITextField()
        field.placeholder = "Text to ignore"
        field.isHidden = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private var resultTextLabel: UILabel = {
        var label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: .init(23))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var reverseButton: UIButton = {
        var button = UIButton()
        button.setTitle("Reverse", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.alpha = 0.5
        button.layer.cornerRadius = 10
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        addGesture()
        addObeservers()
        defaultConfiguration()
        setupUI()
    }
    
    private func defaultConfiguration() {
        self.reverseTextField.delegate = self
        self.textToIngoreTextField.delegate = self
        state = .initial
    }
    
    private func addTargets() {
        reverseButton.addTarget(self, action: #selector (handleButtonTap), for: .touchUpInside)
        segmentControl.addTarget(self, action: #selector (handleSegmentControlChange), for: .valueChanged)
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(gesture)
    }
    
    private func addObeservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: Selectors
    @objc private func handleSegmentControlChange() {
        let isDefaultSegment = segmentControl.selectedSegmentIndex == 0
        textToIngoreTextField.isHidden = isDefaultSegment
        textToIngoreTextField.isUserInteractionEnabled = !isDefaultSegment
        infoLabel.isHidden = !isDefaultSegment
        
        if isDefaultSegment {
            textToIngoreTextField.text = ""
        }
        
        if reverseTextField.text != "" {
            state = .typing
        }
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func handleButtonTap() {
        switch state {
        case .typing:
            state = .result
        case .result:
            state = .initial
        default:
            break
        }
    }
    
    
    private func changeState() {
        switch state {
        case .initial:
            reverseButton.alpha = 0.5
            reverseButton.isUserInteractionEnabled = false
            reverseButton.setTitle("Reverse", for: .normal)
            
            reverseTextField.text = ""
            
            dividerView.backgroundColor = .lightGray
            
            resultTextLabel.text = ""
        case .typing:
            reverseButton.alpha = 1
            reverseButton.isUserInteractionEnabled = true
            reverseButton.setTitle("Reverse", for: .normal)
            dividerView.backgroundColor = .systemBlue
        case .result:
            reverseButton.setTitle("Clear", for: .normal)
            resultTextLabel.text = service.reverseString(str: reverseTextField.text, state: segmentControl.selectedSegmentIndex == 0 ? true : false, ignoreSymbols: textToIngoreTextField.text)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(reverseTextField)
        view.addSubview(dividerView)
        view.addSubview(segmentControl)
        view.addSubview(infoLabel)
        view.addSubview(textToIngoreTextField)
        view.addSubview(resultTextLabel)
        view.addSubview(reverseButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 120),
            
            reverseTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            reverseTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reverseTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            dividerView.topAnchor.constraint(equalTo: reverseTextField.bottomAnchor, constant: 15),
            dividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
            dividerView.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            segmentControl.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 10),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            infoLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            textToIngoreTextField.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10),
            textToIngoreTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textToIngoreTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            resultTextLabel.topAnchor.constraint(equalTo: textToIngoreTextField.bottomAnchor, constant: 15),
            resultTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultTextLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            reverseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reverseButton.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            reverseButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        bottomButtonConstraint = reverseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        bottomButtonConstraint?.isActive = true
    }
}
//MARK: TextField delagate
extension ReverseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == reverseTextField {
            let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if text.isEmpty {
                self.state = .initial
            } else {
                self.state = .typing
            }
        }
        if textField == textToIngoreTextField {
            let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            self.state = .typing
        }
        return true
    }
}
// MARK: keyboard notification
extension ReverseViewController {
    @objc private func keyboardWillShow(notification:Notification) {
        if let keyboardFreme = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFreme.height
            
            bottomButtonConstraint?.constant = -keyboardHeight
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        bottomButtonConstraint?.constant = -40
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
