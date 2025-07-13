//
//  NetworkManager.swift
//  front
//
//  Created by 김병관 on 7/7/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [TokenInjectingURLProtocol.self] + (config.protocolClasses ?? [])
        self.session = URLSession(configuration: config)
    }
    
    func makeRequest(path: String, method: String = "GET", body: Data? = nil, type: String = "json") -> URLRequest? {
        guard let baseURL = URL(string: AppConfig.shared.baseURL),
              let url = URL(string: path, relativeTo: baseURL) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        if body != nil {
            request.setValue("application/\(type)", forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    func request(_ request: URLRequest, retryCount: Int = 0, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 401, retryCount == 0 {
                // 🔄 토큰 갱신 시도
                TokenRefresher.shared.refresh { success in
                    if success {
                        // ✅ 새 토큰으로 재시도
                        var newRequest = request
                        if let mutableRequest = (newRequest as NSURLRequest).mutableCopy() as? NSMutableURLRequest {
                            URLProtocol.removeProperty(forKey: "TokenInjected", in: mutableRequest)
                            newRequest = mutableRequest as URLRequest
                        }
                        
                        self.request(newRequest, retryCount: retryCount + 1, completion: completion)
                    } else {
                        // ❌ 재시도 실패 -> 세션 종료 및 로그인 화면으로 리다이렉트
                        DispatchQueue.main.async {
                            SessionManager.shared.logout() // ✅ 이 라인 추가
                        }
                        completion(data, response, error) // ❌ 재시도 실패
                    }
                }
            } else {
                completion(data, response, error)
            }
        }.resume()
    }
}

extension NetworkManager {
    func makeMultipartRequest(path: String, boundary: String, body: Data, method: String = "POST") -> URLRequest? {
        guard let baseURL = URL(string: AppConfig.shared.baseURL),
              let url = URL(string: path, relativeTo: baseURL) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        return request
    }
}
