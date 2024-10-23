//
//  ViewController.swift
//  Reverse Words
//
//  Created by Igor Plastun on 21.10.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    var state: ReverseState = .initial {
        didSet {
            changeState()
        }
    }
    
    private var reversedString = ""
    private var isReversed: Bool = false
    private var bottomButtonConstraint: NSLayoutConstraint?
    private var service: Service = Service()
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
    
    private var reverseTextLabel: UILabel = {
        var label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: .init(23))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dividerView: UIView = {
        var view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        addGesture()
        addObeservers()
        
        setupUI()
        
        self.reverseTextField.delegate = self
        state = .initial
    }
    
    private func addTargets() {
        reverseButton.addTarget(self, action: #selector (handleButtonTap), for: .touchUpInside)
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
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func handleButtonTap() {
        if state == .typing{
            state = .result
        }else if state == .result{
            state = .initial
        }
    }
    
    @objc private func keyboardWillShow(notification:Notification) {
        if let keyboardFreme = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFreme.height
            
            bottomButtonConstraint?.constant = -keyboardHeight
            
            UIView.animate(withDuration: 0.3) {
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
    
    private func changeState() {
        switch state {
        case .initial:
            reverseButton.alpha = 0.5
            reverseButton.isUserInteractionEnabled = false
            reverseButton.setTitle("Reverse", for: .normal)
            
            reverseTextField.text = ""
            
            dividerView.backgroundColor = .lightGray
            
            reverseTextLabel.text = ""
        case .typing:
            reverseButton.alpha = 1
            reverseButton.isUserInteractionEnabled = true
            reverseButton.setTitle("Reverse", for: .normal)
            dividerView.backgroundColor = .systemBlue
        case .result:
            reverseButton.setTitle("Clear", for: .normal)
            reverseTextLabel.text = service.reverseString(str: reverseTextField.text)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(reverseTextField)
        view.addSubview(dividerView)
        view.addSubview(reverseTextLabel)
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
            
            reverseTextLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 15),
            reverseTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reverseTextLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            reverseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reverseButton.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            reverseButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        bottomButtonConstraint = reverseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        bottomButtonConstraint?.isActive = true
    }
}
//MARK: TextField delagate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if text.isEmpty {
            self.state = .initial
        } else {
            self.state = .typing
        }
        return true
    }
}
