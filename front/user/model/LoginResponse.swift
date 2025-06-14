//
//  LoginResponse.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

struct LoginResponse: Decodable {
    let id: Int64
    let userInfo: UserInfoDto
}

struct UserInfoDto: Decodable {
    let id: Int64
    let loginId: String
    let nickname: String
    let userType: String
    let point: Int
}
