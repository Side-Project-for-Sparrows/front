//
//  TransferUserView.swift
//  front
//
//  Created by 김병관 on 7/20/25.


import Foundation
import SwiftUI

struct TransferSheetView: View {
    let boardId: Int
    let onTransferConfirmed: (Int64) -> Void
    let onCancel: () -> Void

    @StateObject private var viewModel = TransferUserViewModel()
    @State private var selectedUserId: Int64?

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("불러오는 중...")
                } else if let error = viewModel.error {
                    Text("에러: \(error)").foregroundColor(.red)
                } else {
                    List(viewModel.members) { member in
                        HStack {
                            Text(member.nickname)
                            Spacer()
                            if selectedUserId == member.userId {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedUserId = member.userId
                        }
                    }
                }
            }
            .navigationTitle("위임할 멤버 선택")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("확인") {
                        if let id = selectedUserId {
                            onTransferConfirmed(id)
                        }
                    }
                    .disabled(selectedUserId == nil) // ❗선택 안되면 비활성화
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소", action: onCancel)
                }
            }
        }
        .onAppear {
            viewModel.fetchMembers(boardId: boardId)
        }
    }
}

