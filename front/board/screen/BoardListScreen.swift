//
//  BoardListScreen.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import SwiftUI

struct BoardListScreen: View {
    @StateObject private var viewModel = BoardListViewModel()
    @State private var showingCreateView = false

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("불러오는 중...")
                } else if let error = viewModel.error {
                    Text("에러: \(error)")
                        .foregroundColor(.red)
                } else if let boards = viewModel.boards {
                    BoardListView(boards: boards)
                } else {
                    Text("아직 아무 데이터도 없음")
                }
            }
            .navigationTitle("내 게시판")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateView = true
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showingCreateView) {
                BoardCreateScreen()
            }
            .onAppear {
                viewModel.fetchBoards()
            }
        }
    }
}
