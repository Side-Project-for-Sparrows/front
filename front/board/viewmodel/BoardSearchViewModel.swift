//
//  BoardSearchViewModel.swift
//  front
//
//  Created by 김병관 on 7/20/25.
//

import Foundation

class BoardSearchViewModel: ObservableObject {
    @Published var results: [BoardSearchResponseDto] = []
    @Published var isLoading = false
    @Published var error: String? = nil

    func search(keyword: String) {
        guard !keyword.isEmpty else { return }

        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(AppConfig.shared.baseURL)/board/search?query=\(encodedKeyword)") else { return }

        isLoading = true
        error = nil

        let request = URLRequest(url: url)
        NetworkManager.shared.request(request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data {
                    do {
                        let boards = try JSONDecoder().decode([BoardSearchResponseDto].self, from: data)
                        self.results = boards
                    } catch {
                        self.error = "디코딩 실패: \(error.localizedDescription)"
                    }
                } else {
                    self.error = error?.localizedDescription ?? "알 수 없는 에러"
                }
            }
        }
    }

    func requestJoin(board: BoardSearchResponseDto, enterCode: String?) {
        guard let url = URL(string: "\(AppConfig.shared.baseURL)/board/join") else { return }

        let requestBody = BoardJoinRequestDto(
            boardId: board.boardId,
            enterCode: enterCode
        )

        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            print("JSON 인코딩 실패")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        isLoading = true
        error = nil

        NetworkManager.shared.request(request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.error = "요청 실패: \(error.localizedDescription)"
                }else if let response = response as? HTTPURLResponse, (409...409).contains(response.statusCode){
                    self.error = "이미 가입한 게시판입니다"        
                }else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    self.error = "서버 오류: \(response.statusCode)"
                } else {
                    print("가입 요청 성공")
                }
            }
        }
    }


}
