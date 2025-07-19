//
//  SessionManager.swift
//  front
//
//  Created by 김병관 on 7/12/25.
//

import Foundation
import UIKit

class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published var isLoggedIn: Bool = AppConfig.shared.getUserSession() != nil

    func logout() {
        AppConfig.shared.deleteUserSession()
        // 🔴 반드시 메인 쓰레드에서 변경
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.resetToLoginScreen()
        }
    }

    func login(session: UserSession) {
        AppConfig.shared.setUerSession(session: session)
    
        DispatchQueue.main.async {
            self.isLoggedIn = true
        }
    }
    
    private func resetToLoginScreen() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            sceneDelegate.window?.rootViewController = loginVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
