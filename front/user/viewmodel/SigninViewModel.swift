//
//  SigninViewModel.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import Foundation

class SigninViewModel {
    private let signinService = SigninService()
    
    // Callbacks
    var onSigninSuccess: ((AuthResponse) -> Void)?
    var onSigninFailure: ((String) -> Void)?
    
    // Validation callbacks
    var onValidationError: ((String, String?) -> Void)? // (field, message or nil)
    var onValidationSuccess: (() -> Void)?
    
    // Input fields
    var loginId: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var nickname: String = ""
    var selectedSchool: School?
    var userType: String = "OFFICIAL"
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    func validateInputs() -> Bool {
        var isValid = true
        
        // 아이디 검증
        if loginId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onValidationError?("loginId", "아이디를 입력해주세요")
            isValid = false
        } else {
            onValidationError?("loginId", nil)
        }
        
        // 비밀번호 검증
        if password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onValidationError?("password", "비밀번호를 입력해주세요")
            isValid = false
        } else {
            onValidationError?("password", nil)
        }
        
        // 비밀번호 확인 검증
        if confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onValidationError?("confirmPassword", "비밀번호 확인을 입력해주세요")
            isValid = false
        } else if password != confirmPassword {
            onValidationError?("confirmPassword", "비밀번호가 일치하지 않습니다")
            isValid = false
        } else {
            onValidationError?("confirmPassword", nil)
        }
        
        // 닉네임 검증
        if nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onValidationError?("nickname", "닉네임을 입력해주세요")
            isValid = false
        } else {
            onValidationError?("nickname", nil)
        }
        
        // 학교 선택 검증
        if selectedSchool == nil {
            onValidationError?("school", "학교를 선택해주세요")
            isValid = false
        } else {
            onValidationError?("school", nil)
        }
        
        if isValid {
            onValidationSuccess?()
        }
        
        return isValid
    }
    
    func signin() {
        guard let school = selectedSchool else {
            onSigninFailure?("학교를 선택해주세요")
            return
        }
        
        let request = SigninRequest(
            id: loginId.trimmingCharacters(in: .whitespacesAndNewlines),
            pw: password,
            schoolId: school.id,
            nickname: nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            userType: userType,
            latitude: latitude,
            longitude: longitude
        )
        
        signinService.signin(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.onSigninSuccess?(response)
            case .failure(let error):
                // 서버에서 오는 에러 메시지 전체를 로그로 출력
                if let signinError = error as? SigninServiceError {
                    switch signinError {
                    case .serverMessage(let message):
                        print("서버 에러 메시지: \(message)")
                        self?.onSigninFailure?(message)
                        return
                    }
                }
                if let urlError = error as? URLError {
                    print("URLError: \(urlError)")
                } else if let decodingError = error as? DecodingError {
                    print("DecodingError: \(decodingError)")
                } else {
                    print("Error: \(error)")
                }
                // 만약 서버에서 에러 메시지 바디가 있다면 출력
                if let nsError = error as NSError?,
                   let data = nsError.userInfo["data"] as? Data,
                   let errorString = String(data: data, encoding: .utf8) {
                    print("서버 에러 바디: \(errorString)")
                    self?.onSigninFailure?(errorString)
                } else {
                    self?.onSigninFailure?(error.localizedDescription)
                }
            }
        }
    }
} 
