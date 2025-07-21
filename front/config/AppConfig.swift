//
//  AppConfig.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import KeychainAccess

class AppConfig {
    static let shared = AppConfig()

    let baseURL: String
        
    private init() {
        #if DEBUG
        //self.baseURL = "http://unstoppableworm.iptime.org" // 실서버

        self.baseURL = "http://localhost:7080" // 로컬 개발용        #else
        //self.baseURL = "http://unstoppableworm.iptime.org" // 실서버

        #endif
    }
    
    public func setUerSession(session: UserSession){
        let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "sparrows")
            .accessibility(.afterFirstUnlock)
        keychain["accessToken"] = session.accessToken
        keychain["refreshToken"] = session.refreshToken
        UserDefaults.standard.set(session.id, forKey: "userId")
        UserDefaults.standard.set(session.nickname, forKey: "nickname")
    }
    
    public func deleteUserSession() {
        let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "sparrows")
        
        // Keychain 값 삭제
        do {
            try keychain.remove("accessToken")
            try keychain.remove("refreshToken")
        } catch let error {
            print("❌ Keychain 삭제 오류: \(error)")
        }
        
        // UserDefaults 값 삭제
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "nickname")
        defaults.removeObject(forKey: "userType")
    }

    
    public func getUserSession() -> UserSession? {
        let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "sparrows")
        
        guard
            let accessToken = keychain["accessToken"],
            let refreshToken = keychain["refreshToken"],
            let userId = UserDefaults.standard.object(forKey: "userId") as? Int64,
            let nickname = UserDefaults.standard.string(forKey: "nickname")
            //let userType = UserDefaults.standard.string(forKey: "userType")
        else {
            return nil
        }
        
        let session = UserSession(
            id: userId,
            nickname: nickname,
            email: "", // 이메일을 저장하고 있지 않다면 빈 문자열 또는 추후 추가
            accessToken: accessToken,
            refreshToken: refreshToken
        )
        
        return session
    }
    
    public func updateAccessToken(token: String){
        let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "sparrows")
        keychain["accessToken"] = token
    }
}

struct UserSession {
    let id: Int64
    let nickname: String
    let email: String
    let accessToken: String
    let refreshToken: String
}
