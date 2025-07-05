//
//  LoginViewModel.swift
//  front
//
//  Created by ?��?��??? on 6/14/25.
//

import Foundation
import UIKit

class PostViewModel {
    
    // Output
    var onSearchPostSuccess: ((Post) -> Void)?
    var onSearchPostFailure: ((String) -> Void)?
    var onSearchPostImageSuccess: ((UIImage) -> Void)?

    func searchPost(postId: Int64) {
        PostService.fetchPostDetail(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    self?.onSearchPostSuccess?(post)
                    
                    // postImageDetailDtos에서 첫 번째 이미지 URL 사용
                    if let imageUrl = post.postImageDetailDtos?.first?.url {
                        let fullUrl: String
                        if imageUrl.hasPrefix("http") {
                            fullUrl = imageUrl
                        } else {
                            fullUrl = "http://unstoppableworm.iptime.org/post/image/\(imageUrl)"
                        }

                        PostService.fetchPostImage(from: fullUrl) { image in
                            if let image = image {
                                self?.onSearchPostImageSuccess?(image)
                            } else {
                                print("⚠️ 이미지 로딩 실패 또는 nil")
                            }
                        }
                    } else {
                        print("⚠️ 이미지 URL 없음 또는 이미지 리스트 없음")
                    }

                case .failure(let error):
                    self?.onSearchPostFailure?(error.localizedDescription)
                }
            }
        }
    }

}

