//
//  Post.swift
//  front
//
//  Created by Quadroue4 on 6/28/25.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: Int64
    let boardId: Int64
    let writerId: Int64
    let nickname: String
    let title: String
    let content: String
    let likes: Int
    let views: Int
    let isHidden: Bool?
    let createdAt: String?
    let updatedAt: String?
    
    // Optional arrays for related entities
    let likeDetailDtos: [Like]?
    let commentDetailDtos: [Comment]?
    let postImageDetailDtos: [PostImage]?
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case boardId
        case writerId
        case nickname
        case title
        case content
        case likes
        case views
        case isHidden
        case createdAt
        case updatedAt
        case likeDetailDtos
        case commentDetailDtos
        case postImageDetailDtos
    }
}
