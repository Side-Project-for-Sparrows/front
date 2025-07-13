//
//  PostListViewModel.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import UIKit

class PostListViewModel: ObservableObject {
    @Published var posts: [PostSummaryResponseDto]?
    @Published var isLoading = false
    @Published var error: String?

    func fetchPosts(boardId: Int) {
        isLoading = true
        error = nil

        guard let request = NetworkManager.shared.makeRequest(path: "/board/\(boardId)/posts") else {
            error = "URL 생성 실패"
            isLoading = false
            return
        }

        NetworkManager.shared.request(request) { data, response, err in
            DispatchQueue.main.async {
                self.isLoading = false

                if let err = err {
                    self.error = err.localizedDescription
                    return
                }

                guard let data = data else {
                    self.error = "데이터 없음"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode([PostSummaryResponseDto].self, from: data)
                    self.posts = decoded
                } catch {
                    self.error = "디코딩 실패: \(error.localizedDescription)"
                }
            }
        }
    }

}
