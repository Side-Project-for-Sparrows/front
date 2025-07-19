// AuthResponse.swift
// 로그인/회원가입 공통 응답 모델
import Foundation

struct AuthResponse: Decodable {
    let id: Int64
    let userInfo: UserInfo
}

struct UserInfo: Decodable {
    let id: Int64
    let loginId: String
    let nickname: String
    let userType: String
    let point: Int
    let accessToken: String
    let refreshToken: String
}
