//
//  ApiManager.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import Foundation
import SwiftUI

enum APIError: Error {
    case internalError
}

class ApiManager: ObservableObject {
    static var shared = ApiManager()
    
    // MARK: -  post command
    func postBuzzerCommand(body: String, completion: @escaping((Result<PostCommandModel?, APIError>) -> Void )) {
        request(path: Path.postBuzzerCommand, method: .POST, body: body, isCommand: true, completion: completion)
    }
    
    // MARK: -  get Telemetry
    func getTelemetry(telemetry: String, completion: @escaping((Result<Telemetry?, APIError>) -> Void)) {
        request(path: Path.getTelemetry + "/\(telemetry)", method: .GET, completion: completion)
    }
    
    // MARK: -  post Query
    func postQuery(body: String, completion: @escaping((Result<QueryModel?, APIError>) -> Void)) {
        request(path: Path.postQuery, method: .POST, body: body, completion: completion)
    }
    
    // MARK: -  request
    private func request<T: Codable>(path: String,
                                     method: Method,
                                     body: String? = nil,
                                     isCommand: Bool = false,
                                     completion: @escaping((Result<T?, APIError>) -> Void)) {
        let pathString = "\(APIConstant.baseDomain)\(path)"
        
        // MARK: - parameter
        var components = URLComponents(string: pathString)!
        components.queryItems = [
            URLQueryItem(name: "api-version", value: "1.1-preview")
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        // MARK: -  request
        var request = URLRequest(url: components.url!)
        
        // MARK: -  http method
        request.httpMethod = "\(method)"
        
        // MARK: -  Authorization
        request.addValue("\(APIConstant.authorizationString)", forHTTPHeaderField: "Authorization")
        request.addValue(" application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")
        
        // body json
        if let body = body {
            if !isCommand {
                let json: [String: Any] = ["query": body]
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                request.httpBody = jsonData
            } else {
                if let number = Int(body) {
                    let json: [String: Any] = ["request": number]
                    let jsonData = try? JSONSerialization.data(withJSONObject: json)
                    request.httpBody = jsonData
                }
            }
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.internalError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.internalError))
                return
            }
            
            // MARK: -  read response
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
            
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                //printDebug(object)
                completion(Result.success(object))
            } catch {
                completion(.failure(.internalError))
            }
        }
        
        dataTask.resume()
    }
}
