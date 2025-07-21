//
//  BoardWithdrawRequestDto.swift
//  front
//
//  Created by 김병관 on 7/20/25.
//

import Foundation

struct BoardWithdrawRequestDto: Codable {
    let boardId: Int
    let userId: Int64
    let transferToUserId: Int64?
}
