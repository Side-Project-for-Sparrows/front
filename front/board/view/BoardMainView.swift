//
//  BoardMainView.swift
//  front
//
//  Created by 김병관 on 7/20/25.
//

import SwiftUI

struct BoardMainView: View {
    var body: some View {
        TabView {
            BoardListView()
                .tabItem {
                    Label("내 게시판", systemImage: "person.3.fill")
                }

            BoardSearchView()
                .tabItem {
                    Label("게시판 탐색", systemImage: "magnifyingglass")
                }
        }
    }
}
