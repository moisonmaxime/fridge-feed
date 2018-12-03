//
//  URLRequestExtension.swift
//  Lynx
//
//  Created by Maxime Moison on 3/9/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

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
                errorHandler(APIError(type: .network))
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {    // check for http errors
                let errorType = APIErrorType.error(for: httpStatus.statusCode)
//                let message = String(bytes: data, encoding: .utf8)?.capitalized
                errorHandler(APIError(type: errorType))
                return
            }

            completionHandler(data)
            return
        }
        task.resume()
    }

}
