//
//  LoginViewModel.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import Foundation

class LoginViewModel {
    var id: String = ""
    var pw: String = ""
    
    // Output
    var onLoginSuccess: ((AuthResponse) -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    private let authService = AuthService()
    
    // Validation callbacks
    var onValidationError: ((String, String?) -> Void)? // field, message
    var onValidationSuccess: (() -> Void)?
    
    func validateInputs() -> Bool {
        var isValid = true
        
        if id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onValidationError?("id", "아이디를 입력해주세요")
            isValid = false
        } else if pw.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onValidationError?("id", "비밀번호를 입력해주세요")
            isValid = false
        } else {
            onValidationError?("id", nil)
        }
        
        if isValid {
            onValidationSuccess?()
        }
        
        return isValid
    }
    
    func login() {
        let request = LoginRequest(id: id, pw: pw)
        print(request)
        authService.login(request: request) { [weak self] result, rawData in
            if let rawData = rawData, let rawString = String(data: rawData, encoding: .utf8) {
                print("[로그인 응답 raw data] \n\(rawString)")
                if case .failure(_) = result {
                    self?.onLoginFailure?(rawString)
                    return
                }
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.onLoginSuccess?(response)
                case .failure(let error):
                    self?.onLoginFailure?(error.localizedDescription)
                }
            }
        }
    }
}
