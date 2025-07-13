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
    
    func login() {
        guard !id.isEmpty, !pw.isEmpty else {
            onLoginFailure?("아이디와 비밀번호를 입력하세요.")
            return
        }
        
        guard let url = URL(string: "\(AppConfig.shared.baseURL)/user/auth/login") else {
            onLoginFailure?("잘못된 서버 주소입니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "id": id,
            "pw": pw
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            onLoginFailure?("요청 생성 실패: \(error.localizedDescription)")
            return
        }
        
        NetworkManager.shared.request(request) { [weak self] data, response, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let error = error {
                    self.onLoginFailure?("네트워크 오류: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.onLoginFailure?("응답이 없습니다.")
                    return
                }
                
                guard httpResponse.statusCode == 200,
                      let data = data
                else {
                    self.onLoginFailure?("로그인 실패: 상태코드 \(httpResponse.statusCode)")
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(AuthResponse.self, from: data)
                    let info = decoded.userInfo
                    
                    let user = UserSession(
                        id: info.id,
                        name: info.nickname,
                        email: info.loginId,
                        authToken: info.accessToken,
                        refreshToken: info.refreshToken
                    )
                    
                    AppConfig.shared.currentUser = user
                    UserDefaults.standard.set(info.accessToken, forKey: "authToken")
                    UserDefaults.standard.set(info.refreshToken, forKey: "refreshToken")
                    UserDefaults.standard.set(info.id, forKey: "userId")
                    
                    self.onLoginSuccess?(decoded)
                } catch {
                    self.onLoginFailure?("응답 파싱 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
