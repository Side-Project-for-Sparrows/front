//
//  CommentListView.swift
//  front
//
//  Created by 김병관 on 7/14/25.
//

import Foundation
import SwiftUI

struct CommentListView: View {
    let postId: Int64
    var page: Int = 0
    @StateObject private var viewModel = CommentListViewModel()

    @State private var newComment: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("댓글")
                .font(.headline)
                .padding(.bottom, 4)

            // ✅ 현재 페이지 표시
            Text("현재 페이지: \(viewModel.currentPage + 1)")
                .font(.caption)
                .foregroundColor(.gray)

            if let comments = viewModel.comments {
                ForEach(comments, id: \.id) { comment in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(comment.content)
                            .font(.body)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            } else {
                Text("아직 아무 데이터도 없음")
            }
            
            PageNavigator<CommentPageResponse>(
                baseURL: AppConfig.shared.baseURL + "/post/comment/\(postId)",
                currentPage: $viewModel.currentPage,
                totalPages: $viewModel.totalPages,
                onPageChange: { pageResponse in
                    viewModel.comments = pageResponse.content
                    viewModel.currentPage = pageResponse.pageable.pageNumber
                    viewModel.totalPages = pageResponse.totalPages
                }
            )

            Divider().padding(.vertical, 8)

            TextField("댓글을 입력하세요", text: $newComment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 4)

            Button(action: {
                viewModel.writeComment(postId: postId, content: newComment)
                newComment = ""
            }) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("댓글 작성")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .disabled(newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .onAppear {
            viewModel.fetchComments(postId: postId)
        }
    }
}
