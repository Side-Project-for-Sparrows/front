//
//  PostSummaryResponseDto.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation

struct PostSummaryResponseDto: Codable {
    let postId: Int64
    let title: String
    let nickname: String
    let likeCount: Int
    let commentCount: Int
    let viewCount: Int
    let createdAt: String
}
