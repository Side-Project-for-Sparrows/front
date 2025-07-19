//
//  PostCreateViewModel.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import SwiftUI
import PhotosUI

class PostCreateViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedImages: [UIImage] = []
    @Published var isSubmitting = false
    @Published var submitError: String?

    func submitPost(boardId: Int, completion: @escaping (Bool) -> Void) {
        let boundary = UUID().uuidString
        
        guard let userId = AppConfig.shared.getUserSession()?.id else{
            SessionManager.shared.logout()
            return
        }
        
        let body = createMultipartBody(userId: userId, boardId: boardId, boundary: boundary)

        guard let request = NetworkManager.shared.makeMultipartRequest(path: "/post", boundary: boundary, body: body) else {
            completion(false)
            return
        }

        isSubmitting = true
        submitError = nil

        NetworkManager.shared.request(request) { data, response, error in
            DispatchQueue.main.async {
                self.isSubmitting = false

                if let error = error {
                    self.submitError = error.localizedDescription
                    completion(false)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    self.submitError = "서버 오류 또는 실패"
                    completion(false)
                    return
                }

                completion(true)
            }
        }
    }


    private func createMultipartBody(userId: Int64, boardId: Int, boundary: String) -> Data {
        var body = Data()

        let postJson: [String: Any] = [
            "userId": userId,
            "boardId": boardId,
            "title": title,
            "content": content
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: postJson)

        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"post\"\r\n")
        body.appendString("Content-Type: application/json\r\n\r\n")
        body.append(jsonData)
        body.appendString("\r\n")

        for (index, image) in selectedImages.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }

            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"image\(index).jpg\"\r\n")
            body.appendString("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.appendString("\r\n")
        }

        body.appendString("--\(boundary)--\r\n")
        return body
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
