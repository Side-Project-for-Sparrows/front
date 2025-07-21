//
//  BoardListViewModel.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import Combine

class BoardListViewModel: ObservableObject {
    @Published var boards: [BoardSearchResponseDto] = []
    @Published var isLoading = false
    @Published var error: String? = nil
    @Published var selectedBoardForWithdraw: BoardSearchResponseDto? = nil
    @Published var isTransferSheetPopUp = false
    @Published var searchText: String = ""
    
    var filteredBoards: [BoardSearchResponseDto] {
        if searchText.isEmpty {
            return boards
        } else {
            return boards.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
 
    func fetchBoards() {
        guard let url = URL(string: "\(AppConfig.shared.baseURL)/board/search/user") else { return }

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
    
    func withdraw(boardId: Int, transferTo: Int64?) {
        BoardMemberService.shared.withdraw(boardId: boardId, transferTo: transferTo) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.boards.removeAll { $0.boardId == boardId }
                case .failure(let error):
                    self.error = "탈퇴 실패: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func deleteBoard(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let board = boards[index]

        if board.isBoss {
            BoardMemberService.shared.fetchMembers(boardId: board.boardId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let members):
                        if members.count <= 1 {
                            self.withdraw(boardId: board.boardId, transferTo: nil)
                        } else {
                            self.selectedBoardForWithdraw = board
                            self.isTransferSheetPopUp = true
                        }
                    case .failure:
                        self.error = "멤버 정보를 불러오지 못했습니다."
                    }
                }
            }
        } else {
            self.withdraw(boardId: board.boardId, transferTo: nil)

        }
    }


}

