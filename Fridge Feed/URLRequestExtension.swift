//
//  URLRequestExtension.swift
//  Lynx
//
//  Created by Maxime Moison on 3/9/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

// MARK: - API Error

enum APIError {
    case network
    case server
    case internalError
    case invalidAPIKey
    case invalidCredentials
    case notFound
    case notAcceptable
    case unknown
}

extension APIError {
    var message: String {
        switch self {
        case .network: return "Check your internet connection"             // internal
        case .server: return "Oh my! Something went wrong"                 // http - 500
        case .invalidAPIKey: return "Please sign in again"                      // http - 403
        case .invalidCredentials: return "Invalid Credentials"                  // http - 403
        case .internalError: return "Oops! Something went wrong"                // internal
        case .notFound: return "Not Found"
        case .notAcceptable: return "Invalid Input"
        case .unknown: return "No clue, bud!"
        }
    }
    
    static func error(for statusCode: Int) -> APIError {
        switch statusCode {
        case 403: return UserSettings.isLoggedIn ? .invalidAPIKey : .invalidCredentials
        case 500: return .server
        case 400, 404: return .notFound // 400 is there because 'not found in user's stuff'
        case 422: return .notAcceptable
        default: return .unknown
        }
    }
}

// MARK: - URL Request

extension URLRequest {

    enum RequestType: String {
        case POST
        case GET
        case PUT
        case DELETE
    }

    init?(url: String, content: [String: Encodable]=[:], type: RequestType, forceUnauthorized: Bool=false) {
        //  print(url)
        guard let url = URL(string: url),
            let jsonData = try? JSONSerialization.data(withJSONObject: content, options: .prettyPrinted) else {
                return nil
        }
        self.init(url: url)
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.httpMethod = type.rawValue
        if !content.isEmpty {
            self.httpBody = jsonData
        }

        if let token = UserSettings.accessKey,
            !forceUnauthorized {
            self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    func getJsonData(completionHandler: @escaping (Data) -> Void,
                     errorHandler: @escaping (APIError) -> Void) {
        let task = URLSession.shared.dataTask(with: self) { data, response, error in
            guard let data = data, error == nil else {                                   // check for fundamental networking error
                errorHandler(.network)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {    // check for http errors
                errorHandler(APIError.error(for: httpStatus.statusCode))
                return
            }

            completionHandler(data)
            return
        }
        task.resume()
    }

}
