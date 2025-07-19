//
//  AppConfig.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation

class AppConfig {
    static let shared = AppConfig()
    
    let baseURL: String
    
    var currentUser: UserSession?
    
    private init() {
        #if DEBUG
        self.baseURL = "http://unstoppableworm.iptime.org" // 실서버

        //self.baseURL = "http://localhost:7080" // 로컬 개발용        #else
        //self.baseURL = "http://unstoppableworm.iptime.org" // 실서버

        #endif
    }
}

struct UserSession {
    let id: Int64
    let name: String
    let email: String
    let authToken: String
    let refreshToken: String
}
