//
//  AuthService.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import Alamofire

struct AuthService {
    static func login(request: LoginRequest, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let url = "http://localhost:8080/api/auth/login"
        
        AF.request(url,
                   method: .post,
                   parameters: request,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Content-Type": "application/json"])
        .validate()
        .responseDecodable(of: LoginResponse.self) { response in
            completion(response.result.mapError { $0 as Error })
        }
    }
}
