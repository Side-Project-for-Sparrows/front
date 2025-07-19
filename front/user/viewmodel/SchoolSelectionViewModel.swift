//
//  SchoolSelectionViewModel.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import Foundation

class SchoolSelectionViewModel {
    private let signinService = SigninService()
    
    // Callbacks
    var onSchoolSearchSuccess: (([School]) -> Void)?
    var onSchoolSearchFailure: ((String) -> Void)?
    
    func searchSchools(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onSchoolSearchSuccess?([])
            return
        }
        
        signinService.searchSchools(query: query) { [weak self] result in
            switch result {
            case .success(let schools):
                self?.onSchoolSearchSuccess?(schools)
            case .failure(let error):
                self?.onSchoolSearchFailure?(error.localizedDescription)
            }
        }
    }
} 
