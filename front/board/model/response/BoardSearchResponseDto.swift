//
//  BoardSearchResponseDto.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation

struct BoardSearchResponseDto: Codable, Identifiable {
    var id: Int { boardId } // For SwiftUI's List
    let boardId: Int
    let name: String
    let schoolId: Int
    let isPublic: Bool
    let description: String
}
