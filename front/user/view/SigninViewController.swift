//
//  SigninViewController.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import UIKit
import CoreLocation
import KeychainAccess

class SigninViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var loginIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var loginIdErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var nicknameErrorLabel: UILabel!
    @IBOutlet weak var schoolErrorLabel: UILabel!
    
    @IBOutlet weak var schoolSelectionButton: UIButton!
    @IBOutlet weak var selectedSchoolLabel: UILabel!
    
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    private let viewModel = SigninViewModel()
    private let locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupLocationManager()
        hideAllValidationErrors()
        //        selectedSchoolLabel.isHidden = true
    }
    
    // MARK: - Setup
    private func bindViewModel() {
        viewModel.onSigninSuccess = { [weak self] response in
            // 회원가입 성공 시 정보 저장 (로그인과 동일)
            let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "sparrows")
                .accessibility(.afterFirstUnlock)
            keychain["accessToken"] = response.userInfo.accessToken
            keychain["refreshToken"] = response.userInfo.refreshToken
            UserDefaults.standard.set(response.userInfo.id, forKey: "userId")
            UserDefaults.standard.set(response.userInfo.nickname, forKey: "nickname")
            UserDefaults.standard.set(response.userInfo.userType, forKey: "userType")
            self?.showAlert(title: "회원가입 성공", message: "회원가입이 완료되었습니다!") {
                self?.dismiss(animated: true)
            }
        }
        
        viewModel.onSigninFailure = { [weak self] errorMessage in
            // JSON에서 message만 추출
            if let data = errorMessage.data(using: .utf8),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = json["message"] as? String {
                self?.showToast(message: message)
            } else {
                self?.showAlert(title: "회원가입 실패", message: "서버에서 적절하지 않은 응답이 왔습니다.")
            }
        }
        
        viewModel.onValidationError = { [weak self] field, message in
            self?.showValidationError(field: field, message: message)
        }
        
        viewModel.onValidationSuccess = { [weak self] in
            self?.hideAllValidationErrors()
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        viewModel.latitude = location.coordinate.latitude
        viewModel.longitude = location.coordinate.longitude
        print("현재 위치: 위도=\(location.coordinate.latitude), 경도=\(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보를 가져오지 못했습니다: \(error.localizedDescription)")
    }
    
    // MARK: - Actions
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        // 입력값 ViewModel에 전달
        viewModel.loginId = loginIdTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
        viewModel.nickname = nicknameTextField.text ?? ""
        
        // 유효성 검사
        let isValid = validateInputs()
        if isValid {
            hideAllValidationErrors()
            viewModel.signin()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func schoolSelectionButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let schoolSelectionVC = storyboard.instantiateViewController(withIdentifier: "SchoolSelectionViewController") as? SchoolSelectionViewController {
            schoolSelectionVC.onSchoolSelected = { [weak self] selectedSchool in
                print("선택된 학교:", selectedSchool.name) // 디버깅용
                self?.viewModel.selectedSchool = selectedSchool
                self?.selectedSchoolLabel.text = selectedSchool.name
                self?.selectedSchoolLabel.isHidden = false
                self?.schoolErrorLabel.isHidden = true
                self?.schoolErrorLabel.text = ""
            }
            
            let navController = UINavigationController(rootViewController: schoolSelectionVC)
            present(navController, animated: true)
        }
    }
    
    // MARK: - Validation
    private func validateInputs() -> Bool {
        var isValid = true
        
        // 아이디
        if viewModel.loginId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            loginIdErrorLabel.text = "아이디를 입력해주세요."
            loginIdErrorLabel.isHidden = false
            isValid = false
        } else {
            loginIdErrorLabel.isHidden = true
        }
        
        // 비밀번호
        if viewModel.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            passwordErrorLabel.text = "비밀번호를 입력해주세요."
            passwordErrorLabel.isHidden = false
            isValid = false
        } else {
            passwordErrorLabel.isHidden = true
        }
        
        // 비밀번호 확인
        if viewModel.confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            confirmPasswordErrorLabel.text = "비밀번호 확인을 입력해주세요."
            confirmPasswordErrorLabel.isHidden = false
            isValid = false
        } else if viewModel.password != viewModel.confirmPassword {
            confirmPasswordErrorLabel.text = "비밀번호가 다릅니다."
            confirmPasswordErrorLabel.isHidden = false
            isValid = false
        } else {
            confirmPasswordErrorLabel.isHidden = true
        }
        
        // 닉네임
        if viewModel.nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nicknameErrorLabel.text = "닉네임을 입력해주세요."
            nicknameErrorLabel.isHidden = false
            isValid = false
        } else {
            nicknameErrorLabel.isHidden = true
        }
        
        // 학교 선택
        if viewModel.selectedSchool == nil {
            schoolErrorLabel.text = "학교를 선택해주세요."
            schoolErrorLabel.isHidden = false
            isValid = false
        } else {
            schoolErrorLabel.isHidden = true
        }
        
        return isValid
    }
    
    private func hideAllValidationErrors() {
        loginIdErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
        nicknameErrorLabel.isHidden = true
        schoolErrorLabel.isHidden = true
    }
    
    private func showValidationError(field: String, message: String) {
        switch field {
        case "loginId":
            loginIdErrorLabel.text = message
            loginIdErrorLabel.isHidden = false
        case "password":
            passwordErrorLabel.text = message
            passwordErrorLabel.isHidden = false
        case "confirmPassword":
            confirmPasswordErrorLabel.text = message
            confirmPasswordErrorLabel.isHidden = false
        case "nickname":
            nicknameErrorLabel.text = message
            nicknameErrorLabel.isHidden = false
        case "school":
            schoolErrorLabel.text = message
            schoolErrorLabel.isHidden = false
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate
extension SigninViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginIdTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            nicknameTextField.becomeFirstResponder()
        case nicknameTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
