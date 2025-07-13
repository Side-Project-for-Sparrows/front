//
//  SigninService.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import Foundation

class SigninService {
    private let baseURL = "http://unstoppableworm.iptime.org" // 서버 URL 변경
    
    func signin(request: SigninRequest, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/auth/join") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                // HTTP 상태코드 확인
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    // 에러 응답이 JSON이 아닐 수 있으므로 plain text로 시도
                    if let errorString = String(data: data, encoding: .utf8) {
                        print("서버 에러 바디: \(errorString)")
                        completion(.failure(SigninServiceError.serverMessage(errorString)))
                    } else {
                        completion(.failure(NetworkError.unknown))
                    }
                    return
                }
                
                do {
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    completion(.success(authResponse))
                } catch {
                    // 디코딩 에러 발생 시에도 원본 데이터가 plain text면 메시지로 전달
                    if let errorString = String(data: data, encoding: .utf8), !errorString.isEmpty {
                        print("서버 에러 바디(디코딩 실패): \(errorString)")
                        completion(.failure(SigninServiceError.serverMessage(errorString)))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func searchSchools(query: String, completion: @escaping (Result<[School], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/index/school?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let schools = try JSONDecoder().decode([School].self, from: data)
                    completion(.success(schools))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case unknown
}

enum SigninServiceError: Error {
    case serverMessage(String)
} 
