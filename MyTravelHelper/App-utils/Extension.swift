//
//  Extension.swift
//  MyTravelHelper
//
//  Created by Chinthan on 09/08/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation
extension URL {
    mutating func addPath(_ path: String) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        urlComponents.path = path
        self = urlComponents.url ?? self
    }

    mutating func appendQueryItem(_ name: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        self = urlComponents.url ?? self
    }
}

extension NSError {
    static let nilData = NSError(domain: "com.example.com.MyTravelHelper",
                                 code: 404,
                                 userInfo: [NSLocalizedDescriptionKey : "Data is nil"])
    static let badResponse = NSError(domain: "com.example.com.MyTravelHelper",
                                 code: 400,
                                 userInfo: [NSLocalizedDescriptionKey : "Unable to decode response"])
    static let noNetwork = NSError(domain: "com.example.com.MyTravelHelper",
                                     code: -1009,
                                     userInfo: [NSLocalizedDescriptionKey : "The Internet connection appears to be offline."])
}

extension Date {
    static var TrainDate: String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: today)
        return dateString
    }
}
