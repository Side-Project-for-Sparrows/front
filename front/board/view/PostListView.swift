//
//  PostListView.swift
//  front
//
//  Created by 김병관 on 7/5/25.
//

import Foundation
import SwiftUI

struct PostListView: View {
    let posts: [PostSummaryResponseDto]

    var body: some View {
        List(posts, id: \.postId) { post in
            NavigationLink(destination: PostDetailScreen(postId: post.postId)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ID \(post.postId)")
                    Text(post.title)
                        .font(.headline)
                    Text("by \(post.nickname) · 💬 \(post.commentCount) ❤️ \(post.likeCount)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(formatDate(post.createdAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    func formatDate(_ iso: String) -> String {
        return String(iso.prefix(10)) // "2025-07-05T..." → "2025-07-05"
    }
}

