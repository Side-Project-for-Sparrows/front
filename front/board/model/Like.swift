//
//  Like.swift
//  front
//
//  Created by Quadroue4 on 6/28/25.
//

// Related entity models
import Foundation


struct Like: Identifiable, Codable {
    let id: Int64
    let postId: Int64
    let userId: Int64
    let createdAt: Date
    let updatedAt: Date
}
