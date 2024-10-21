//
//  ViewController.swift
//  Reverse Words
//
//  Created by Igor Plastun on 21.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private var reversedString = ""
    private var isReversed:Bool = false
    
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
        button.addTarget(self, action: #selector (reverseString), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func reverseString() {
        if isReversed{
            reverseButton.setTitle("Reverse", for: .normal)
            stringTextField.text = ""
            reverseStringLabel.text = ""
            reversedString = ""
            bottomLine.backgroundColor = .lightGray
            reverseButton.alpha = 0.5
            reverseButton.isUserInteractionEnabled = false
            isReversed.toggle()
        }else{
            if let str = stringTextField.text{
                let words = str.split(separator: " ")
                let reverseWords = words.map{String($0.reversed())}
                reversedString = reverseWords.joined(separator: " ")
                reverseStringLabel.text = reversedString
                bottomLine.backgroundColor = .lightGray
                reverseButton.setTitle("Clear", for: .normal)
                
                isReversed.toggle()
            }
        }
    }
    
    @objc func textFieldDidChange() {
        if stringTextField.text == "" {
            reverseButton.alpha = 0.5
            reverseButton.isUserInteractionEnabled = false
            bottomLine.backgroundColor = .lightGray
        }else{
            reverseButton.alpha = 1
            reverseButton.isUserInteractionEnabled = true
            bottomLine.backgroundColor = .blue
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
            
            
            reverseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            reverseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reverseButton.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            reverseButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }

}

