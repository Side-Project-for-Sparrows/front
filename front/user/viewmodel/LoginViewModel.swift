//
//  LoginViewModel.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import Foundation

class LoginViewModel {
    
    // Input
    var id: String = ""
    var pw: String = ""
    
    // Output
    var onLoginSuccess: ((AuthResponse) -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    func login() {
        guard !id.isEmpty, !pw.isEmpty else {
            onLoginFailure?("아이디와 비밀번호를 입력하세요.")
            return
        }
        
        let request = LoginRequest(id: id, pw: pw)
        print(request)
        AuthService.login(request: request) { [weak self] result, rawData in
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
