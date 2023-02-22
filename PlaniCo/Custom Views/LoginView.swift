//
//  LoginView.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//

import UIKit

// Login View presented when peforming Email & Password Login Flow
class LoginView: UIView {
  var emailTextField: UITextField! {
    didSet {
      emailTextField.textContentType = .emailAddress
    }
  }

  var passwordTextField: UITextField! {
    didSet {
      passwordTextField.textContentType = .password
    }
  }

  var emailTopConstraint: NSLayoutConstraint!
  var passwordTopConstraint: NSLayoutConstraint!

  lazy var loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("Autentifică-mă", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.setTitleColor(.highlightedLabel, for: .highlighted)
    let accentColor = UIColor(named: "AccentColor")
    button.setBackgroundImage(accentColor?.image, for: .normal)
    button.setBackgroundImage(accentColor?.highlighted.image, for: .highlighted)
    button.clipsToBounds = true
    button.layer.cornerRadius = 14
    return button
  }()

  lazy var createAccountButton: UIButton = {
    let button = UIButton()
    let accentColor = UIColor(named: "AccentColor")
    button.setTitle("Creează cont", for: .normal)
    button.setTitleColor(accentColor ?? .secondaryLabel, for: .normal)
    button.setTitleColor(UIColor.secondaryLabel.highlighted, for: .highlighted)
    return button
  }()
    
    lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "Or"
        label.textColor = .secondaryLabel
        return label
    }()


  convenience init() {
    self.init(frame: .zero)
    setupSubviews()
  }

  // MARK: - Subviews Setup

  private func setupSubviews() {
    backgroundColor = .systemBackground
    clipsToBounds = true

    setupFirebaseLogoImage()
    setupEmailTextfield()
    setupPasswordTextField()
    setupLoginButton()
    setupOrLabel()
    setupCreateAccountButton()
  }

  private func setupFirebaseLogoImage() {
    let firebaseLogo = UIImage(named: "firebaseLogo")
    let imageView = UIImageView(image: firebaseLogo)
    imageView.contentMode = .scaleAspectFit
    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -55),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 55),
      imageView.widthAnchor.constraint(equalToConstant: 325),
      imageView.heightAnchor.constraint(equalToConstant: 325),
    ])
  }

  private func setupEmailTextfield() {
    emailTextField = textField(placeholder: "Email", symbolName: "person.crop.circle")
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    addSubview(emailTextField)
    NSLayoutConstraint.activate([
      emailTextField.leadingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.leadingAnchor,
        constant: 15
      ),
      emailTextField.trailingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.trailingAnchor,
        constant: -15
      ),
      emailTextField.heightAnchor.constraint(equalToConstant: 45),
    ])

    let constant: CGFloat = UIDevice.current.orientation.isLandscape ? 15 : 50
    emailTopConstraint = emailTextField.topAnchor.constraint(
      equalTo: safeAreaLayoutGuide.topAnchor,
      constant: constant
    )
    emailTopConstraint.isActive = true
  }

  private func setupPasswordTextField() {
    passwordTextField = textField(placeholder: "Parola", symbolName: "lock.fill")
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    addSubview(passwordTextField)
    NSLayoutConstraint.activate([
      passwordTextField.leadingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.leadingAnchor,
        constant: 15
      ),
      passwordTextField.trailingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.trailingAnchor,
        constant: -15
      ),
      passwordTextField.heightAnchor.constraint(equalToConstant: 45),
    ])

    let constant: CGFloat = UIDevice.current.orientation.isLandscape ? 5 : 20
    passwordTopConstraint =
      passwordTextField.topAnchor.constraint(
        equalTo: emailTextField.bottomAnchor,
        constant: constant
      )
    passwordTopConstraint.isActive = true
  }

  private func setupLoginButton() {
    addSubview(loginButton)
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loginButton.leadingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.leadingAnchor,
        constant: 15
      ),
      loginButton.trailingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.trailingAnchor,
        constant: -15
      ),
      loginButton.heightAnchor.constraint(equalToConstant: 45),
      loginButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5),
    ])
  }
    
//    private func setupOrLabel() {
//        let orLabel = UILabel()
//        orLabel.text = "or"
//        addSubview(orLabel)
//        orLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//          orLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//          orLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
//        ])
//      }
    private func setupOrLabel() {
        let orLabel = UILabel()
        orLabel.text = "sau"
        orLabel.textColor = .gray
        
        let leftLineView = UIView()
        leftLineView.backgroundColor = .gray
        leftLineView.translatesAutoresizingMaskIntoConstraints = false
        leftLineView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        leftLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let rightLineView = UIView()
        rightLineView.backgroundColor = .gray
        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        rightLineView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        rightLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [leftLineView, orLabel, rightLineView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20)
        ])
    }




  private func setupCreateAccountButton() {
    addSubview(createAccountButton)
    createAccountButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      createAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 65),
    ])
  }

  // MARK: - Private Helpers

  private func textField(placeholder: String, symbolName: String) -> UITextField {
    let textfield = UITextField()
    textfield.backgroundColor = .secondarySystemBackground
    textfield.layer.cornerRadius = 14
    textfield.placeholder = placeholder
    // MARK: - systemOrange
    let accentColor = UIColor(named: "AccentColor")
    textfield.tintColor = accentColor ?? .systemOrange
    let symbol = UIImage(systemName: symbolName)
    textfield.setImage(symbol)
    return textfield
  }
}
