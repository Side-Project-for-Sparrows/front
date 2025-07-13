//
//  LoginViewController.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import UIKit
import KeychainAccess

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] response in
            print("로그인 성공, 토큰:", response.id)
            print("로그인 성공, 토큰:", response.userInfo)
            // 로그인 정보 저장
            // accessToken, refreshToken은 Keychain, userId, nickname, userType은 UserDefaults
            let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "sparrows")
                .accessibility(.afterFirstUnlock)
            keychain["accessToken"] = response.userInfo.accessToken
            keychain["refreshToken"] = response.userInfo.refreshToken
            UserDefaults.standard.set(response.userInfo.id, forKey: "userId")
            UserDefaults.standard.set(response.userInfo.nickname, forKey: "nickname")
            UserDefaults.standard.set(response.userInfo.userType, forKey: "userType")
            self?.showAlert(message: "로그인 성공, 나중에 alert 지우고 메인 페이지로 이동하게 연결하면 됨.")
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
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.id = idTextField.text ?? ""
        viewModel.pw = pwTextField.text ?? ""
        
        viewModel.login()
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signinVC = storyboard.instantiateViewController(withIdentifier: "SigninViewController") as? SigninViewController {
            signinVC.modalPresentationStyle = .fullScreen
            present(signinVC, animated: true)
        }
    }

}

