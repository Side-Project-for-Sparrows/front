import SwiftUI

struct PostDetailDto: Codable {
    let postId: Int64
    let boardId: Int
    let writerId: Int64
    let nickname: String
    let title: String
    let content: String
    let likeCount: Int
    let commentCount: Int
    let viewCount: Int
    let postImageDetailDtos: [PostImageDetailDto]
    let createdAt: String // 또는 Date로 변환해서 처리 가능
}

struct PostImageDetailDto: Codable {    
    let key: String
}
