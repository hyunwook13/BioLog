//
//  MockURLSessionDataTask.swift
//  BioLogTests
//
//  Created by 이현욱 on 3/27/25.
//

import Foundation

@testable import BioLog

class MockURLSessionDataTask: URLSessionDataTask {

    var resumeDidCall: (() -> ())?

    override func resume() {
        // 주의: super.resume()호출하면 실제 resume()이 호출되므로 주의
        resumeDidCall?()
    }
}
