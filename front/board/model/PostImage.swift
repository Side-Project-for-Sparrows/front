//
//  PostImage.swift
//  front
//
//  Created by Quadroue4 on 6/28/25.
//

import Foundation


struct PostImage: Identifiable, Codable {
    let id: Int64
    let postId: Int64
    let url: String
}
