//
//  TransferUserViewModel.swift
//  front
//
//  Created by 김병관 on 7/20/25.
//

import Foundation

class TransferUserViewModel: ObservableObject {
    @Published var members: [BoardMember] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    public func fetchMembers(boardId: Int){
        BoardMemberService.shared.fetchMembers(boardId: boardId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let members):
                    self.members = members
                case .failure:
                    self.error = "멤버 정보를 불러오지 못했습니다."
                }
            }
        }
    }
}
