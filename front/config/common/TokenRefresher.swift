//
//  TokenRefresher.swift
//  front
//
//  Created by 김병관 on 7/7/25.
//

import Foundation

class TokenRefresher {
    static let shared = TokenRefresher()
    private var isRefreshing = false
    private var waitingHandlers: [(Bool) -> Void] = []

    func refresh(completion: @escaping (Bool) -> Void) {
        if isRefreshing {
            waitingHandlers.append(completion)
            return
        }

        isRefreshing = true
        waitingHandlers.append(completion)

        guard let refreshToken = AppConfig.shared.currentUser?.refreshToken else {
            self.failAndLogout()
            return
        }

        var request = URLRequest(url: URL(string: "\(AppConfig.shared.baseURL)/auth/refresh")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let newAccessToken = json["accessToken"] as? String
            else {
                self.failAndLogout()
                return
            }

            // 🔑 새로운 토큰 저장
            self.refreshAcceessToken(newAccessToken: newAccessToken)
            self.complete(success: true)
        }.resume()
    }
    
    private func refreshAcceessToken(newAccessToken: String){
        if var currentUser = AppConfig.shared.currentUser {
            let updatedUser = UserSession(
                id: currentUser.id,
                name: currentUser.name,
                email: currentUser.email,
                authToken: newAccessToken,
                refreshToken: currentUser.refreshToken
            )
            AppConfig.shared.currentUser = updatedUser
            self.complete(success: true)
        } else {
            self.failAndLogout()
        }
    }

    private func complete(success: Bool) {
        isRefreshing = false
        waitingHandlers.forEach { $0(success) }
        waitingHandlers.removeAll()
    }

    private func failAndLogout() {
        DispatchQueue.main.async {
            SessionManager.shared.logout()
        }
        self.complete(success: false)
    }
}
