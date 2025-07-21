//
//  BoardListView.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import SwiftUI

struct BoardListView: View {
    @StateObject private var viewModel = BoardListViewModel()
    @State private var showingCreateView = false
    @State private var showingTransferSheet = false

    var body: some View {
        NavigationView {
            VStack{
                BoardSearchBar(text: $viewModel.searchText) // 🔍 검색창 추가
                
                Group {
                    if viewModel.isLoading {
                        ProgressView("불러오는 중...")
                    } else if let error = viewModel.error {
                        Text("에러: \(error)")
                            .foregroundColor(.red)
                    } else {
                        boardListView()
                    }
                }
                .navigationTitle("내 게시판")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingCreateView = true
                        }) {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
                .sheet(isPresented: $showingCreateView) {
                    BoardCreateView {
                        viewModel.fetchBoards()
                    }
                }
                .sheet(isPresented: $viewModel.isTransferSheetPopUp) {
                    if let board = viewModel.selectedBoardForWithdraw {
                        TransferSheetView(
                            boardId: board.boardId,
                            onTransferConfirmed: { transferToUserId in
                                viewModel.withdraw(
                                    boardId: board.boardId,
                                    transferTo: transferToUserId // nil 가능
                                )
                                viewModel.selectedBoardForWithdraw = nil
                                viewModel.isTransferSheetPopUp = false
                            },
                            onCancel: {
                                viewModel.selectedBoardForWithdraw = nil
                                viewModel.isTransferSheetPopUp = false
                            }
                        )
                    }
                }
                .onAppear {
                    viewModel.fetchBoards()
                }
            }
        }
    }
    
    private func boardListView() -> some View {
        List {
            ForEach(viewModel.filteredBoards, id: \.boardId) { board in
                boardRow(board)
            }
            .onDelete { indexSet in
                viewModel.deleteBoard(at: indexSet)
            }
        }
    }

    private func boardRow(_ board: BoardSearchResponseDto) -> some View {
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

