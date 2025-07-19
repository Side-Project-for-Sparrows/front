//
//  PageNavigator.swift
//  front
//
//  Created by 김병관 on 7/14/25.
//

import SwiftUI

struct PageNavigator<T: Decodable>: View {
    let baseURL: String
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    let onPageChange: (T) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Button(action: {
                    currentPage = index
                    fetchPage(page: index)
                }) {
                    Text("\(index + 1)")
                        .padding(6)
                        .background(currentPage == index ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(currentPage == index ? .white : .black)
                        .cornerRadius(6)
                }
            }
        }
    }

    private func fetchPage(page: Int) {
        guard let url = URL(string: "\(baseURL)?page=\(page)") else {
            print("❌ URL 생성 실패")
            return
        }
        
        print("📡 호출 URL: \(url.absoluteString)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        print("page is \(page)")

        NetworkManager.shared.request(request) { data, response, error in
            guard let data = data else {
                print("❌ 네트워크 에러: \(error?.localizedDescription ?? "알 수 없는 에러")")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    onPageChange(decoded)
                }
            } catch {
                print("❌ 디코딩 에러: \(error)")
            }
        }
    }
}
