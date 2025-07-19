//
//  BoardListViewModel.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import Combine

class BoardListViewModel: ObservableObject {
    @Published var boards: [BoardSearchResponseDto]? = []
    @Published var isLoading = false
    @Published var error: String? = nil

    func fetchBoards() {
        guard let userId = AppConfig.shared.getUserSession()?.id else {
            SessionManager.shared.logout()
            return
        }
        
        guard let url = URL(string: "\(AppConfig.shared.baseURL)/board/search/user/\(userId)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        NetworkManager.shared.request(request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let boards = try JSONDecoder().decode([BoardSearchResponseDto].self, from: data)
                        print("게시글 목록:", boards)
                        self.boards = boards
                    } catch {
                        print("디코딩 에러: \(error)")
                    }
                } else {
                    print("에러:", error?.localizedDescription ?? "알 수 없는 에러")
                }
            }
        }
    }

}

