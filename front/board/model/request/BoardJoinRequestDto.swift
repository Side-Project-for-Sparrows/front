//
//  BoardJoinRequestDto.swift
//  front
//
//  Created by 김병관 on 7/21/25.
//

import Foundation

struct BoardJoinRequestDto: Codable {
    let boardId: Int
    let enterCode: String?
}
