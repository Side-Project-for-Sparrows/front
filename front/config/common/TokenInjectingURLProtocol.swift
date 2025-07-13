//
//  TokenInjectingURLProtocol.swift
//  front
//
//  Created by 김병관 on 7/7/25.
//

import Foundation

class TokenInjectingURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        // 중복 처리 방지 (이미 처리된 요청이면 건너뜀)
        if URLProtocol.property(forKey: "TokenInjected", in: request) != nil {
            return false
        }
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        // 요청 복사
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }

        // ✅ Authorization 헤더 삽입 (수정된 부분)
        if let token = AppConfig.shared.currentUser?.authToken {
            mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // 중복 방지 플래그 추가
        URLProtocol.setProperty(true, forKey: "TokenInjected", in: mutableRequest)

        // 원래 요청 수행
        let session = URLSession(configuration: .default)
        session.dataTask(with: mutableRequest as URLRequest) { data, response, error in
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }.resume()
    }

    override func stopLoading() {
        // 아무것도 안 해도 됨
    }
}

