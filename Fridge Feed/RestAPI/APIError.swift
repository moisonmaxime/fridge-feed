//
//  APIError.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

enum APIErrorType {
    case network
    case server
    case internalError
    case invalidAPIKey
    case invalidCredentials
    case notFound
    case notAcceptable
    case noOwnership
    case unknown
}

extension APIErrorType {
    static func error(for statusCode: Int) -> APIErrorType {
        switch statusCode {
        case 403: return UserSettings.isLoggedIn ? .invalidAPIKey : .invalidCredentials
        case 500: return .server
        case 400: return .noOwnership
        case 404: return .notFound // 400 is there because 'not found in user's stuff'
        case 422: return .notAcceptable
        default: return .unknown
        }
    }
}

class APIError: Error {
    let type: APIErrorType
    let information: String?
    
    init(type: APIErrorType, details: String?=nil) {
        self.type = type
        self.information = details
    }
}

extension APIError {
    var message: String {
        if let information = information {
            return information
        }
        switch self.type {
        case .network: return "Check your internet connection"             // internal
        case .server: return "Oh my! Something went wrong"                 // http - 500
        case .invalidAPIKey: return "Please sign in again"                      // http - 403
        case .invalidCredentials: return "Invalid Credentials"                  // http - 403
        case .internalError: return "Oops! Something went wrong"                // internal
        case .notFound: return "Not Found"
        case .notAcceptable: return "Invalid Input"
        case .noOwnership: return "You do not own this!"
        case .unknown: return "No clue, bud!"
        }
    }
    
    static func error(for statusCode: Int) -> APIErrorType {
        switch statusCode {
        case 403: return UserSettings.isLoggedIn ? .invalidAPIKey : .invalidCredentials
        case 500: return .server
        case 400: return .noOwnership
        case 404: return .notFound // 400 is there because 'not found in user's stuff'
        case 422: return .notAcceptable
        default: return .unknown
        }
    }
}
