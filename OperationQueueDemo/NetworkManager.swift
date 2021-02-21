//
//  NetworkManager.swift
//  OperationQueueDemo
//
//  Created by Ankita Kalangutkar on 21/02/21.
//  Copyright © 2021 Ankita Kalangutkar. All rights reserved.
//

import Foundation

class NetworkManager {
    func get(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest.init(url: url)
        let task = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let urlResponse = response as? HTTPURLResponse {
                
                switch urlResponse.statusCode {
                case 200:
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    completion(data, nil)
                case 401:
                    // handle for auth error
                    break
                case 403:
                    // missing file error
                    break
                case 500:
                    // server error
                    break
                default:
                    completion(nil, error)
                }
            }
            
        }
        
        task.resume()
    }
}
