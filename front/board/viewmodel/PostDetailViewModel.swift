//
//  LoginViewModel.swift
//  front
//
//  Created by ?��?��??? on 6/14/25.
//

import Foundation
import UIKit

class PostDetailViewModel: ObservableObject {
    @Published var post: PostDetailDto?
    @Published var isLoading = false
    @Published var error: String?

    func fetchPostDetail(postId: Int64) {
        isLoading = true
        error = nil

        guard let request = NetworkManager.shared.makeRequest(path: "/post/\(postId)") else {
            print("❌ [URL 생성 실패]")
            self.error = "URL 생성 실패"
            isLoading = false
            return
        }

        print("📡 [요청 시작] \(request.url?.absoluteString ?? "nil")")

        NetworkManager.shared.request(request) { data, response, err in
            DispatchQueue.main.async {
                self.isLoading = false

                if let err = err {
                    print("❌ [네트워크 오류] \(err.localizedDescription)")
                    self.error = err.localizedDescription
                    return
                }

                guard let data = data else {
                    print("❌ [응답 데이터 없음]")
                    self.error = "데이터 없음"
                    return
                }

                // 응답 확인용 JSON 출력
                print("📦 [응답 데이터]")
                print(String(data: data, encoding: .utf8) ?? "응답 본문 없음")

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    self.post = try decoder.decode(PostDetailDto.self, from: data)
                    print("✅ [디코딩 성공] \(self.post?.title ?? "제목 없음")")
                } catch {
                    print("❌ [디코딩 실패] \(error)")
                    self.error = "디코딩 실패"
                }
            }
        }
    }

}
