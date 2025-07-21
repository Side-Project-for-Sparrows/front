//
//  BoardMemberService.swift
//  front
//
//  Created by 김병관 on 7/20/25.
//

import Foundation

final class BoardMemberService {
    static let shared = BoardMemberService()  // 싱글톤으로 사용해도 무방

    private init() {}

    func fetchMembers(boardId: Int, completion: @escaping (Result<[BoardMember], Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.shared.baseURL)/board/member/\(boardId)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        NetworkManager.shared.request(request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(BoardMemberResponseDto.self, from: data)
                        completion(.success(decoded.members))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error ?? NSError(domain: "UnknownError", code: -1)))
                }
            }
        }
    }
    
    func withdraw(boardId: Int, transferTo: Int64?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.shared.baseURL)/board/withdraw") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestDto = BoardWithdrawRequestDto(boardId: boardId, userId: AppConfig.shared.getUserSession()?.id ?? 0, transferToUserId: transferTo)

        do {
            let jsonData = try JSONEncoder().encode(requestDto)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        NetworkManager.shared.request(request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(BoardWithdrawResponseDto.self, from: data)
                        completion(.success(decoded.result))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error ?? NSError(domain: "UnknownError", code: -1)))
                }
            }
        }
    }

}

