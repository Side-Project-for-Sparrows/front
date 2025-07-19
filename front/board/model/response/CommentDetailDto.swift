//
//  CommentDetailDto.swift
//  front
//
//  Created by 김병관 on 7/14/25.
//

import SwiftUI

struct CommentDetailDto: Codable {
    let id: Int64
    let userId: Int64
    let nickname: String?
    let content: String
    let likeCount: Int
}

struct CommentPageResponse: Codable {
    let content: [CommentDetailDto]
    let totalPages: Int
    let pageable: Pageable
}

