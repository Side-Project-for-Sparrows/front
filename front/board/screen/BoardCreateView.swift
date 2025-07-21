//
//  PostCreateScreen.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct BoardCreateView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = BoardCreateViewModel()
    
    let onCreated : (() -> Void)

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("제목")) {
                    TextField("게시판 이름을 입력하세요", text: $viewModel.name)
                }

                Section(header: Text("설명")) {
                    TextEditor(text: $viewModel.description)
                        .frame(height: 180)
                }

                if let error = viewModel.submitError {
                    Text("❌ \(error)").foregroundColor(.red)
                }

                Button(action: {
                    viewModel.submitBoard() { success in
                        if success {
                            onCreated()
                            dismiss()
                        }
                    }
                }) {
                    if viewModel.isSubmitting {
                        ProgressView()
                    } else {
                        Text("작성하기")
                    }
                }
            }
            .navigationTitle("게시글 작성")
        }
    }
}
