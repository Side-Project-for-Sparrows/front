//
//  SigninRequest.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

struct SigninRequest: Encodable {
    let id: String
    let pw: String
    let schoolId: Int
    let nickname: String
    let userType: String
    let latitude: Double
    let longitude: Double
} 