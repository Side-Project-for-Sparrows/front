//
//  PostDetailScreen.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import SwiftUI


struct PostDetailScreen: View {
    @StateObject private var viewModel = PostDetailViewModel()
    let postId: Int64

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("로딩 중...")
            } else if let post = viewModel.post {
                PostDetailView(post: post)
            } else if let error = viewModel.error {
                Text("에러: \(error)")
            } else {
                Text("아직 아무 데이터도 없음")
            }
        }
        .onAppear {
            viewModel.fetchPostDetail(postId: postId)
        }
    }
}
