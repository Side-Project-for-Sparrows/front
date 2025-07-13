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

    @Published var isLoggedIn: Bool = AppConfig.shared.currentUser != nil

    func logout() {
        AppConfig.shared.currentUser = nil
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "userId")
        // 🔴 반드시 메인 쓰레드에서 변경
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.resetToLoginScreen()
        }
    }

    func login(user: UserSession) {
        AppConfig.shared.currentUser = user
        UserDefaults.standard.set(user.authToken, forKey: "authToken")
        UserDefaults.standard.set(user.id, forKey: "userId")
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
