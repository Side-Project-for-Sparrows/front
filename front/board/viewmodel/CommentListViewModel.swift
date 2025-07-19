//
//  CommentListViewModel.swift
//  front
//
//  Created by 김병관 on 7/14/25.
//

import Foundation
import Combine

class CommentListViewModel: ObservableObject {
    @Published var comments: [CommentDetailDto]? = []
    @Published var currentPage: Int = 0
    @Published var totalPages: Int = 1
    @Published var isLoading = false
    @Published var error: String? = nil

    func fetchComments(postId: Int64, page: Int = 0) {
        guard let url = URL(string: "\(AppConfig.shared.baseURL)/post/comment/\(postId)?page=\(page)") else {
            print("❌ URL 생성 실패")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        NetworkManager.shared.request(request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let comments = try JSONDecoder().decode(CommentPageResponse.self, from: data)
                        self.comments = comments.content
                        self.currentPage = comments.pageable.pageNumber
                        self.totalPages = comments.totalPages
                    } catch {
                        print("디코딩 에러 on fetch comment: \(error)")
                    }
                } else {
                    print("에러:", error?.localizedDescription ?? "알 수 없는 에러")
                }
            }
        }
    }
    
    func writeComment(postId: Int64, content: String) {
        
        guard let userId = AppConfig.shared.currentUser?.id else { return }
        
        guard let url = URL(string: "\(AppConfig.shared.baseURL)/post/comment") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "userId": userId,
            "postId": postId,
            "content": content
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("JSON 직렬화 실패: \(error)")
            return
        }
        
        NetworkManager.shared.request(request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(CommentCreateResponseDto.self, from: data)
                        if result.success {
                            print("댓글 작성 성공")
                            // 추가 로직: 댓글 다시 불러오기, 입력창 초기화 등
                            self.fetchComments(postId: postId)
                        } else {
                            print("댓글 작성 실패")
                        }
                    } catch {
                        print("디코딩 에러 on write comment: \(error)")
                    }
                } else {
                    print("에러:", error?.localizedDescription ?? "알 수 없는 에러")
                }
            }
        }
    }
}

struct CommentCreateResponseDto: Codable {
    let success: Bool
}

