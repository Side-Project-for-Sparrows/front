//
//  BoardListView.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import SwiftUI

struct BoardListView: View {
    let boards: [BoardSearchResponseDto]

    var body: some View {
        List(boards, id: \.boardId) { board in
            NavigationLink(destination: PostListScreen(boardId: board.boardId)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(board.name)
                        .font(.headline)
                    Text(board.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("학교 ID: \(board.schoolId), 공개 여부: \(board.isPublic ? "공개" : "비공개")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
