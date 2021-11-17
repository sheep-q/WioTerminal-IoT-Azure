//
//  ApiManager.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import Foundation

enum APIError: Error {
    case internalError
}

class ApiManager: ObservableObject {
    static var shared = ApiManager()
    
    func getTelemetry(telemetry: String, completion: @escaping((Result<Telemetry, APIError>) -> Void)) {
        request(path: Path.getTelemetry + "/\(telemetry)", method: .GET, completion: completion)
    }
    
    private func request<T: Codable>(path: String,
                                     method: Method,
                                     completion: @escaping((Result<T, APIError>) -> Void)) {
        let pathString = "\(APIConstant.baseDomain)\(path)"
        print(pathString)

        // MARK: -  Heading 
        var components = URLComponents(string: pathString)!
            components.queryItems = [
                URLQueryItem(name: "api-version", value: "1.0")
            ]
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        // authorization
        var request = URLRequest(url: components.url!)
        request.httpMethod = "\(method)"
        request.addValue("\(APIConstant.authorizationString)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.internalError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.internalError))
                return
            }
            
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(object))
            } catch {
                completion(.failure(.internalError))
            }
        }
        
        dataTask.resume()
    }
}
