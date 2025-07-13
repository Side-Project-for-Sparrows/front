//
//  PostListScreen.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//


import Foundation
import SwiftUI

struct PostListScreen: View {
    @StateObject private var viewModel = PostListViewModel()
    @State private var showingCreatePostView = false

    let boardId: Int

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
            } else if let error = viewModel.error {
                Text("에러: \(error)")
                    .foregroundColor(.red)
            } else if let posts = viewModel.posts {
                PostListView(posts: posts)
            } else {
                Text("아직 아무 데이터도 없음") // 👈 이걸로 최소한 한 뷰가 그려지도록
            }
        }
        .navigationTitle("게시글 목록")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingCreatePostView = true
                }) {
                    Image(systemName: "square.and.pencil") // ✏️ 글쓰기 아이콘
                }
            }
        }
        .sheet(isPresented: $showingCreatePostView) {
            PostCreateScreen(boardId: boardId)
        }
        .onAppear {
            print("hi")
            viewModel.fetchPosts(boardId: boardId)
        }
    }
    
}

