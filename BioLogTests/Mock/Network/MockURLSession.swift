//
//  MockURLSession.swift
//  BioLogTests
//
//  Created by 이현욱 on 3/27/25.
//

import Foundation

@testable import BioLog

class MockURLSession: URLSessionable {
    
    // 설정 가능한 응답 상태
    struct Response {
        let data: Data?
        let statusCode: Int
        let error: Error?
    }
    
    // 각 엔드포인트별 응답 매핑
    private var responses: [String: Response] = [:]
    private(set) var requestCallCount = 0
    private(set) var lastRequest: URLRequest?
    var makeRequestFail = false
    
    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }
    
    // 응답 설정 메서드
    func setResponse(for path: String, data: Data?, statusCode: Int = 200, error: Error? = nil) {
        responses[path] = Response(data: data, statusCode: statusCode, error: error)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        requestCallCount += 1
        lastRequest = request
        
        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = { [weak self] in
            guard let self = self,
                  let url = request.url,
                  let response = self.getResponse(for: url) else {
                completionHandler(nil, nil, NSError(domain: "Test", code: -1))
                return
            }
            
            let urlResponse = HTTPURLResponse(
                url: url,
                statusCode: response.statusCode,
                httpVersion: "2",
                headerFields: nil
            )
            
            completionHandler(response.data, urlResponse, response.error)
        }
        
        return sessionDataTask
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        requestCallCount += 1
        lastRequest = request
        
        guard let url = request.url,
              let response = getResponse(for: url) else {
            throw NSError(domain: "MockURLSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "응답을 찾을 수 없습니다"])
        }
        
        if let error = response.error {
            throw error
        }
        
        guard let data = response.data else {
            throw NSError(domain: "MockURLSession", code: -2, userInfo: [NSLocalizedDescriptionKey: "데이터가 없습니다"])
        }
        
        let urlResponse = HTTPURLResponse(
            url: url,
            statusCode: response.statusCode,
            httpVersion: "2",
            headerFields: nil
        )!
        
        return (data, urlResponse)
    }
    
    private func getResponse(for url: URL) -> Response? {
        // URL 경로로 매칭되는 응답 찾기
        if let path = URLComponents(url: url, resolvingAgainstBaseURL: true)?.path {
            return responses[path]
        }
        return nil
    }
}
