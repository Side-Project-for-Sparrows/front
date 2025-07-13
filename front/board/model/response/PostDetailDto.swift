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
    let commentDetailDtos: [CommentDetailDto]
    let postImageDetailDtos: [PostImageDetailDto]
    let createdAt: String // 또는 Date로 변환해서 처리 가능
}

struct CommentDetailDto: Codable {
    let id: Int64
    let userId: Int64
    let nickname: String?
    let content: String
    let likeCount: Int
}

struct PostImageDetailDto: Codable {    
    let key: String
}
