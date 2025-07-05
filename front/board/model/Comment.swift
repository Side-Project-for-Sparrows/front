//
//  Comment.swift
//  front
//
//  Created by Quadroue4 on 6/28/25.
//



import Foundation

struct Comment: Identifiable, Codable {
    let id: Int64
    let postId: Int64
    let userId: Int64
    let content: String
    let createdAt: Date
    let updatedAt: Date
}
