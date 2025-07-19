//
//  LoginViewController.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] in
            self?.goToMenuView()
        }
        
        viewModel.onLoginFailure = { [weak self] errorMessage in
            // JSON에서 message만 추출
            if let data = errorMessage.data(using: .utf8),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = json["message"] as? String {
                self?.showToast(message: message)
            } else {
                self?.showAlert(message: "서버에 문제가 발생했습니다. 잠시후 다시 시도해주세요.")
            }
        }

        viewModel.onValidationError = { [weak self] field, message in
            switch field {
            case "id":
                self?.loginErrorLabel.text = message
                self?.loginErrorLabel.isHidden = (message == nil)
            default:
                break
            }
        }
    
    }
    
    private func goToMenuView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuView") as? MenuView {
            let nav = UINavigationController(rootViewController: menuVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.id = idTextField.text ?? ""
        viewModel.pw = pwTextField.text ?? ""
        
        // 유효성 검사
        let isValid = viewModel.validateInputs()
        if isValid {
            loginErrorLabel.isHidden = true
            viewModel.login()
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signinVC = storyboard.instantiateViewController(withIdentifier: "SigninViewController") as? SigninViewController {
            signinVC.modalPresentationStyle = .fullScreen
            present(signinVC, animated: true)
        }
    }
}

