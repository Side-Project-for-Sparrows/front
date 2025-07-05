//
//  AuthService.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import Alamofire

struct PostService {
    static func fetchPostDetail(postId: Int64, completion: @escaping (Result<Post, Error>) -> Void) {
        let url = "http://unstoppableworm.iptime.org/post/"+String(postId)  // ← 서버 주소에 맞게 바꾸세요

        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzgyNjQ4MzQ5LCJpYXQiOjE3NTExMTIzNDl9.2YJgu_gOfMHkDf48qY3ST49bXC9j3bGlZhDn3Et1mco"
        AF.request(url,
                   method: .get,
                   headers: ["Accept": "application/json", "Authorization": "Bearer \(accessToken)"])
        .validate()
        .responseData{ response in
            print("📡 상태 코드: \(response.response?.statusCode ?? -1)")
            if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                print("📦 원시 응답: \(raw)")
            } else {
                print("⚠️ 응답 바디 없음")
            }
        }
        .responseDecodable(of: Post.self) { response in
            completion(response.result.mapError { $0 as Error })
        }
    }

    static func fetchPostImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzgyNjQ4MzQ5LCJpYXQiOjE3NTExMTIzNDl9.2YJgu_gOfMHkDf48qY3ST49bXC9j3bGlZhDn3Et1mco"

        AF.request(url,
                method: .get,
                headers: ["Accept": "application/json", "Authorization": "Bearer \(accessToken)"]).responseData { response in
            switch response.result {
            case .success(let data):
                let image = UIImage(data: data)
                completion(image)
            case .failure(let error):
                print("❌ 이미지 요청 실패: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

}
