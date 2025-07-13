//
//  SchoolSelectionViewModel.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import Foundation

class SchoolSelectionViewModel {
    private let baseURL = "http://unstoppableworm.iptime.org"
    
    // Callbacks
    var onSchoolSearchSuccess: (([School]) -> Void)?
    var onSchoolSearchFailure: ((String) -> Void)?
    
    func searchSchools(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onSchoolSearchSuccess?([])
            return
        }
        
        let request = SchoolSearchRequest(domain: "school", query: query)
        let url = URL(string: "\(baseURL)/index/school")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            onSchoolSearchFailure?("요청 데이터 인코딩 실패")
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.onSchoolSearchFailure?(error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    self?.onSchoolSearchFailure?("데이터가 없습니다")
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(SchoolListResponse.self, from: data)
                    self?.onSchoolSearchSuccess?(response.schoolDtos)
                } catch {
                    self?.onSchoolSearchFailure?(error.localizedDescription)
                }
            }
        }.resume()
    }
} 