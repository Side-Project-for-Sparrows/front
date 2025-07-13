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
                PostDetailView(post: post) // ← 아래에 정의된 View 사용
            } else if let error = viewModel.error {
                Text("에러: \(error)")
            } else {
                Text("아직 아무 데이터도 없음") // 👈 이걸로 최소한 한 뷰가 그려지도록
            }
        }
        .onAppear {
            print(postId)
            print("JSDFLKSJFD")
            viewModel.fetchPostDetail(postId: postId)
        }
    }
}
