//
//  PostCreateViewModel.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//
import Foundation
import SwiftUI

class BoardCreateViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var schoolId: Int = 0
    @Published var isPublic: Bool = false
    @Published var isSubmitting = false
    @Published var submitError: String?

    func submitBoard(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(AppConfig.shared.baseURL)/board") else {
            completion(false)
            return
        }
        
        guard let userId = AppConfig.shared.currentUser?.id else {
            //submitError = "로그인이 필요합니다"
            //completion(false)
            //SessionManager.shared.logout() // ✅ 즉시 로그인 화면으로 리다이렉트
            print(#function, "로그인이 필요합니다")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "userId": userId,
            "name": name,
            "schoolId": schoolId,
            "isPublic": isPublic,
            "description": description
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            submitError = "JSON 변환 실패"
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

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    self.submitError = "서버 오류 또는 실패"
                    completion(false)
                    return
                }

                completion(true)
            }
        }
    }
}
