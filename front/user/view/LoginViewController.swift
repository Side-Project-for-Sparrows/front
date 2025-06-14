//
//  LoginViewController.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] response in
            print("로그인 성공, 토큰:", response.id)
            print("로그인 성공, 토큰:", response.userInfo)
            // TODO: 토큰 저장 및 화면 전환
            self?.showAlert(message: "로그인 성공!")
        }
        
        viewModel.onLoginFailure = { [weak self] errorMessage in
            self?.showAlert(message: errorMessage)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.id = idTextField.text ?? ""
        viewModel.pw = pwTextField.text ?? ""
        
        viewModel.login()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

