//
//  DeviceTemplateAPI.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import Foundation
import SwiftUI

enum APIError: Error {
    case internalError
}

class DeviceTemplateAPI {
    
//    func getDeviceTemplate(completion: @escaping((Result<T, APIError>) -> Void)) {
//        request(endPoint: .getDeviceTemplate, method: .GET, completion: completion)
//    }
    
    private func request<T: Codable>(endPoint: Endpoint,
                                     method: Method,
                                     completion: @escaping((Result<T, APIError>) -> Void)) {
        let path = "\(APIConstant.baseDomain)\(endPoint.rawValue)"
        
        guard let url = URL(string: path) else {
            completion(.failure(.internalError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.addValue("Bearer \(APIConstant.authorizationString)", forHTTPHeaderField: "Authentication")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.internalError))
                return
            }
            
            do {
                guard let data = data else {
                    completion(.failure(.internalError))
                    return
                }
                
                let object = try JSONDecoder().decode(T.self,
                                                      from: data)
                completion(Result.success(object))
            } catch {
                completion(.failure(.internalError))
            }
        }
        
        dataTask.resume()
    }
}
