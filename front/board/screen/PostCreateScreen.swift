//
//  PostCreateScreen.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct PostCreateScreen: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = PostCreateViewModel()
    @State private var selectedItems: [PhotosPickerItem] = []

    let boardId: Int

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("제목")) {
                    TextField("제목을 입력하세요", text: $viewModel.title)
                }

                Section(header: Text("내용")) {
                    TextEditor(text: $viewModel.content)
                        .frame(height: 180)
                }

                Section(header: Text("이미지")) {
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images) {
                        Text("사진 선택")
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }

                if let error = viewModel.submitError {
                    Text("❌ \(error)").foregroundColor(.red)
                }

                Button(action: {
                    viewModel.submitPost(boardId: boardId) { success in
                        if success {
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
        .onChange(of: selectedItems) {
            Task {
                viewModel.selectedImages = []
                for item in selectedItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        let resized = resizeImage(uiImage, maxWidth: 800)
                        guard let imageData = resized.jpegData(compressionQuality: 0.4) else { continue }
                        guard let resizedImage = UIImage(data: imageData) else { continue }
                        viewModel.selectedImages.append(resizedImage)
                    }
                }
            }
        }
    }
    
    
    func resizeImage(_ image: UIImage, maxWidth: CGFloat) -> UIImage {
        let size = image.size
        let scale = maxWidth / size.width
        let newSize = CGSize(width: maxWidth, height: size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
}
