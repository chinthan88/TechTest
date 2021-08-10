//
//  NetworkClient.swift
//  MyTravelHelper
//
//  Created by Chinthan on 09/08/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation
import XMLParsing

protocol NetworkClientProtocol {
    func perform<T: Decodable>(_ request: URLRequest,
                               decode decodable: T.Type,
                               result: @escaping (Result<T, Error>) -> Void)
}

class NetworkClient: NetworkClientProtocol {

    func perform<T: Decodable>(_ request: URLRequest,
                               decode decodable: T.Type,
                               result: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data
                else {
                    result(.failure(NSError.nilData))
                    return
                }
            guard let object = try? XMLDecoder().decode(decodable.self, from: data)
                else {
                    debugPrint(String(decoding: data, as: UTF8.self))
                    result(.failure(NSError.badResponse))
                    return
                }
            debugPrint(String(decoding: data, as: UTF8.self))
            result(.success(object))
        }.resume()
    }
}
