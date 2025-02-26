//
//  URLSessionable.swift
//  HaloGlow
//
//  Created by 이현욱 on 1/3/25.
//

import Foundation

/// URLSession 테스트를 위한 protocol (Provider 생성자에서 해당 인터페이스 참조)
protocol URLSessionable {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionable {}
