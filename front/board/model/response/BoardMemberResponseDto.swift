//
//  MemberInfo.swift
//  front
//
//  Created by 김병관 on 7/20/25.
//

import Foundation

struct BoardMemberResponseDto: Decodable {
    let members: [BoardMember]
}

struct BoardMember: Identifiable, Decodable {
    let userId: Int64
    let nickname: String

    var id: Int64 { userId }  // For List/ForEach
}
