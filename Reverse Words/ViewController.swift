//
//  ViewController.swift
//  Reverse Words
//
//  Created by Igor Plastun on 21.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private var state:ReverseState = .initial{
        didSet{
            changeState()
        }
    }
    private var reversedString = ""
    private var isReversed:Bool = false
    private var bottomButtonConstraint:NSLayoutConstraint?
    
    private let titleLabel:UILabel = {
        var label = UILabel()
        label.text = "Reverse Words"
        label.font = .systemFont(ofSize: .init(32), weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel:UILabel = {
        var label = UILabel()
        label.text = "The application will reverse your words. Please type text below"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = .systemFont(ofSize: .init(15))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var stringTextField:UITextField = {
        var field = UITextField()
        field.placeholder = "Text to reverse"
        field.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private var reverseStringLabel:UILabel = {
        var label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: .init(23))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var bottomLine:UIView = {
       var view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var reverseButton:UIButton = {
        var button = UIButton()
        button.setTitle("Reverse", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.alpha = 0.5
        button.layer.cornerRadius = 10
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector (handleButtonTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(gesture)
        self.stringTextField.delegate = self
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        state = .initial
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func handleButtonTap() {
        if state == .typing{
            state = .result
        }else if state == .result{
            state = .initial
        }

    }
    
  
    
    @objc func textFieldDidChange() {
        if stringTextField.text == ""{
            state = .initial
        }else{
            state = .typing
        }
        
    }
    

    
    @objc func keyboardWillShow(notification:Notification) {
        if let keyboardFreme = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFreme.height
            
            bottomButtonConstraint?.constant = -keyboardHeight
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide() {
        bottomButtonConstraint?.constant = -40
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func changeState(){
        switch state {
        case .initial:
            reverseButton.alpha = 0.5
            reverseButton.isUserInteractionEnabled = false
            reverseButton.setTitle("Reverse", for: .normal)

            stringTextField.text = ""
            
            bottomLine.backgroundColor = .lightGray
          
            reverseStringLabel.text = ""
        case .typing:
            reverseButton.alpha = 1
            reverseButton.isUserInteractionEnabled = true
            reverseButton.setTitle("Reverse", for: .normal)
            bottomLine.backgroundColor = .blue
        case .result:
            reverseButton.setTitle("Clear", for: .normal)
            reverseString()
        }
    }
    
    func reverseString() {
        if let str = stringTextField.text{
            let words = str.split(separator: " ")
            let reverseWords = words.map{String($0.reversed())}
            reversedString = reverseWords.joined(separator: " ")
            reverseStringLabel.text = reversedString
          
        }
    }

    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(stringTextField)
        view.addSubview(bottomLine)
        view.addSubview(reverseStringLabel)
        view.addSubview(reverseButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 120),
            
            stringTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            stringTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stringTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            bottomLine.topAnchor.constraint(equalTo: stringTextField.bottomAnchor, constant: 15),
            bottomLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            bottomLine.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            reverseStringLabel.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 15),
            reverseStringLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reverseStringLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            reverseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reverseButton.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            reverseButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        bottomButtonConstraint = reverseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        bottomButtonConstraint?.isActive = true
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
