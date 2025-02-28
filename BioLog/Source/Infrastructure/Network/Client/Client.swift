//
//  Client.swift
//  HaloGlow
//
//  Created by 이현욱 on 1/3/25.
//

import Foundation

protocol Client {
    func request<R: Decodable, E: RequesteResponsable>(with endpoint: E) async throws -> R where E.Response == R
    func request<E: RequesteResponsable>(with endpoint: E) async throws -> Data
}

class ClientImpl: Client {
    let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func request<E: RequesteResponsable>(with endpoint: E) async throws -> Data {
        let urlRequest = try endpoint.getUrlRequest()
        
        let (data,response) = try await session.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.invalidHttpStatusCode(response.statusCode)
        }
        
        return data
    }
    
    func request<R: Decodable, E: RequesteResponsable>(with endpoint: E) async throws -> R where E.Response == R {
        let urlRequest = try endpoint.getUrlRequest()
        
        guard let (data,response) = try? await session.data(for: urlRequest) else { throw NetworkError.unknownError }
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.responseConvertError
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.invalidHttpStatusCode(response.statusCode)
        }
        
        do {
            return try decode(data: data)
        } catch {
            throw NetworkError.emptyData
        }
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}

// XMLParserDelegate 구현
class BooksXMLParser: NSObject, XMLParserDelegate {
    var books: [BookDTO] = []
    private var currentElement: String = ""
    private var currentTitle: String = ""
    private var currentAuthor: String = ""
    
    let element = "item"
    
    // 시작 태그를 만났을 때
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        
        
        if elementName == element {
            
            currentTitle = ""
            currentAuthor = ""
        }
    }
    
    // 태그 사이의 문자열을 만났을 때
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedString.isEmpty else { return }
        
        print("string: ",string)
        print("trimmedString", trimmedString)
        
        if currentElement == "author_info" {
            currentTitle += trimmedString
            // 새로운 책 객체 시작 시 초기화
            print(trimmedString)
        } else if currentElement == "author" {
            currentAuthor += trimmedString
        }
    }
    
    // 종료 태그를 만났을 때
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == element {
            //            let book = Book(title: currentTitle, author: currentAuthor)
            //            books.append(book)
        }
    }
}
