//
//  PostCreateRequestDto.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation

struct PostCreateRequestDto: Codable {
    let userId: Int64
    let boardId: Int
    let title: String
    let content: String
}
