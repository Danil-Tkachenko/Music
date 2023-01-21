//
//  SignUpViewController.swift
//  Music
//
//  Created by Леонид Шелудько on 18.01.2023.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let validLabel: [UILabel] = {
        var labelArray = [UILabel]()
        for i in 0..<6 {
            let label = UILabel()
            label.text = "Required field"
            label.font = .systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            //label.tag = i
            labelArray.append(label)
        }
        return labelArray
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "First Name"
        return textField
    }()
    
    private let secondNameTextField: UITextField = {
        let textFeild = UITextField()
        textFeild.borderStyle = .roundedRect
        textFeild.placeholder = "Second Name"
        return textFeild
    }()
    
    private let dateTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textFeild = UITextField()
        textFeild.borderStyle = .roundedRect
        textFeild.placeholder = "Phone"
        textFeild.keyboardType = .numberPad
        return textFeild
    }()
    
    private let emailTextField: UITextField = {
        let textFeild = UITextField()
        textFeild.borderStyle = .roundedRect
        textFeild.placeholder = "E-mail"
        return textFeild
    }()
    
    private let passwordTextField: UITextField = {
        let textFeild = UITextField()
        textFeild.borderStyle = .roundedRect
        textFeild.placeholder = "Password"
        textFeild.isSecureTextEntry = true
        return textFeild
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Sign UP", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var elementsStackView = UIStackView()
    private let datePicker = UIDatePicker()
    
    let nameValidType: String.ValidTypes = .name
    let emailValidType: String.ValidTypes = .email
    let passwordValidType: String.ValidTypes = .password

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupDelegate()
        setupDatePicker()
        setConstraints()
        registerKeyboardNotification()
    }
    
    //Удалить из память поднятие клавиатуры
    deinit {
        removeKeyboardNotification()
    }
    
    private func setupViews() {
        title = "Sign UP"
        
        let uiView: [UIView] = [firstNameTextField, secondNameTextField, dateTextField, phoneNumberTextField, emailTextField, passwordTextField]
        var arrangedSubviews = [UIView]()
        var index = 0
        for i in uiView {
            arrangedSubviews.append(i)
            arrangedSubviews.append(validLabel[index])
            index += 1
        }

        elementsStackView = UIStackView(arrangedSubviews: arrangedSubviews,
                                        axis: .vertical,
                                        spacing: 10,
                                        distribution: .fillProportionally)
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(elementsStackView)
        backgroundView.addSubview(loginLabel)
        backgroundView.addSubview(signUpButton)
    }
    
    private func setupDelegate() {
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        dateTextField.delegate = self
    }
    
    private func setupDatePicker() {
        
        datePicker.datePickerMode = .date
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 6
        datePicker.tintColor = .black
        datePicker.contentHorizontalAlignment = .left
        dateTextField.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(datePickerTapped), for: .valueChanged)
    }
    
    @objc private func datePickerTapped() {
        if ageIsValid() {
            validLabel[2].text = "Date is Valid"
            validLabel[2].textColor = .green
        } else {
            validLabel[2].text = "Date is not Valid"
            validLabel[2].textColor = .red
        }
    }
    
    
    //MARK: - Переход
    @objc private func signUpButtonTapped() {
        
        //Проверить все ли поля введены
        //Если не введено(nil) то пустое
        let firstNameText = firstNameTextField.text ?? ""
        let secondNameText = secondNameTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let phoneText = phoneNumberTextField.text ?? ""
        
        //Если пустое или неправильно введено то не даст перейти
        if firstNameText.isValid(validType: nameValidType)
            && secondNameText.isValid(validType: nameValidType)
            && emailText.isValid(validType: emailValidType)
            && passwordText.isValid(validType: passwordValidType)
            && phoneText.count == 18
            && ageIsValid() == true {
            
            DataBase.shared.saveUser(firstName: firstNameText,
                                     secondName: secondNameText,
                                     phone: phoneText,
                                     email: emailText,
                                     pasword: passwordText,
                                     age: datePicker.date)
            loginLabel.text = "Registration complete"
            
        } else {
            loginLabel.text = "Registration"
            alertOk(title: "Error", message: "Fill in all the filds and your age must me 18+ y.o.")
        }
    }
    
    //Метод будет отвечать за все текстфилды
    private func setTextField(textField: UITextField, label: UILabel, validType: String.ValidTypes, validMessage: String, wrongMessge: String, string: String, range: NSRange) {

        let text = (textField.text ?? "") + string
        var result: String
        
        //сейчас при удалении ничего не прроисходит, тк приходит " "
        //range.length будет равен 1, если удалить символ
        if range.length == 1 {
            //1) ищем последний символ
            //2) текст равен от начала до предпоследнего символа
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        } else {
            result = text
        }
        
        //Возвращает false если символ не подходит
        //Не даёт печать текст который мы указали
        
//        if !string.isValid(validType: nameValidType) {
//            let end = text.index(text.startIndex, offsetBy: text.count - 1)
//            result = String(text[text.startIndex..<end])
//        } else {
//            result = text
//        }
        
        textField.text = result
        
        
        //Пошла проверка на валидность
        //Валидность проверяют всю строку
        //Если в строке все символы нам подходят, мы меняем текст снизу текстфилда
        if result.isValid(validType: validType) {
            label.text = validMessage
            label.textColor = .green
        } else {
            label.text = wrongMessge
            label.textColor = .red
        }
    }
    
    private func setPhoneNumberMask(textField: UITextField, mask: String, string: String, range: NSRange) -> String {
        
        let text = textField.text ?? ""
        
        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        
        if result.count == 18 {
            validLabel[3].text = "Phone is valid"
            validLabel[3].textColor = .green
        } else {
            validLabel[3].text = "Phone is not valid"
            validLabel[3].textColor = .red
        }
        
        return result
    }
    
    private func ageIsValid() -> Bool {
        let calendar = NSCalendar.current
        let dateNow = Date()
        let birthday = datePicker.date

        let age = calendar.dateComponents([.year], from: birthday, to: dateNow)
        let ageYear = age.year

        guard let ageUser = ageYear else { return false }
        return (ageUser < 18 ? false : true)
    }

}

//MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case firstNameTextField: setTextField(textField: firstNameTextField,
                                              label: validLabel[0],
                                              validType: nameValidType,
                                              validMessage: "Name is valid",
                                              wrongMessge: "Only A-Z characters, min 1 character",
                                              string: string,
                                              range: range)
        case secondNameTextField: setTextField(textField: secondNameTextField,
                                              label: validLabel[1],
                                              validType: nameValidType,
                                              validMessage: "Name is valid",
                                              wrongMessge: "Only A-Z characters, min 1 character",
                                              string: string,
                                              range: range)
        case emailTextField: setTextField(textField: emailTextField,
                                              label: validLabel[4],
                                              validType: emailValidType,
                                              validMessage: "Email is valid",
                                              wrongMessge: "Email is not valid",
                                              string: string,
                                              range: range)
        case passwordTextField: setTextField(textField: passwordTextField,
                                              label: validLabel[5],
                                              validType: passwordValidType,
                                              validMessage: "Password is valid",
                                              wrongMessge: "Password is not valid",
                                              string: string,
                                              range: range)
        case phoneNumberTextField: phoneNumberTextField.text = setPhoneNumberMask(textField: phoneNumberTextField,
                                                                                  mask: "+X (XXX) XXX-XX-XX",
                                                                                  string: string,
                                                                                  range: range)
        default:
            break
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
   
}

//Поднять клавиатуру

extension SignUpViewController {
    
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //Удалить из памяти обсервер
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        //Узнать размер клавиатуры
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 2)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}

//MARK: - SetConstaraints

extension SignUpViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            elementsStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            elementsStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            elementsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            elementsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: elementsStackView.topAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: elementsStackView.bottomAnchor, constant: 30),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}
