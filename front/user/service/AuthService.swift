//
//  AuthService.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import Alamofire

struct AuthService {
    func login(request: LoginRequest, completion: @escaping (Result<AuthResponse, Error>, Data?) -> Void) {
        let url = "\(AppConfig.shared.baseURL)/user/auth/login"
        
        AF.request(url,
                   method: .post,
                   parameters: request,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Content-Type": "application/json"])
        .validate()
        .responseDecodable(of: AuthResponse.self) { response in
            completion(response.result.mapError { $0 as Error }, response.data)
        }
    }
}
