//
//  RestAPI.swift
//  Lynx
//
//  Created by Maxime Moison on 3/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation
import UIKit

private enum API: String {
    case login = "auth/login/"
    case register = "auth/register/"
    case containers = "containers/"
    case item = "item/"
}

extension API {
    private static let endpointUrl = "https://cse111-fridge.herokuapp.com/"
    
    var url: String {
        return API.endpointUrl + self.rawValue
    }
    
    func url(with parameters: [String: String]) -> String {
        
        let parametersString = parameters.map { (parameterKey, parameter) -> String in
            return "\(parameterKey)=\(parameter)"
            }.joined(separator: "&")
        
        return (API.endpointUrl + self.rawValue + parametersString)
    }
}

class RestAPI {
    
    /*
     - Template for API Request -
     static func doSomething(completionHandler: @escaping ()->(), errorHandler: @escaping (APIError) -> ()) {
     let postContent:[String: Any] = [:]
     guard let request = URLRequest(url: API.login.url, content: postContent, type: .POST) else {
     errorHandler(.internalError)
     return
     }
     request.getJsonData(completionHandler: { data in
     //Deal w/ data from response
     completionHandler()
     }, errorHandler: errorHandler)
     }*/
    
    static func login(user: String,
                      password: String,
                      completionHandler: @escaping () -> Void,
                      errorHandler: @escaping (APIError) -> Void) {
        let postContent = ["username": user, "password": password]
        guard let request = URLRequest(url: API.login.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            guard let loginResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                errorHandler(.internalError)
                return
            }
            UserSettings.accessKey = loginResponse.accessKey
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    static func register(user: String,
                         password: String,
                         email: String,
                         name: String,
                         completionHandler: @escaping () -> Void,
                         errorHandler: @escaping (APIError) -> Void) {
        let postContent = ["username": user, "password": password, "email": email, "name": name]
        guard let request = URLRequest(url: API.register.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            guard let loginResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                errorHandler(.internalError)
                return
            }
            UserSettings.accessKey = loginResponse.accessKey
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    
    
    
    
    
    
    static func listContainers(completionHandler: @escaping ([ContainerInfo]) -> Void,
                               errorHandler: @escaping (APIError) -> Void) {
        guard let request = URLRequest(url: API.containers.url, type: .GET) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            guard let containers = try? JSONDecoder().decode([ContainerInfo].self, from: data) else {
                errorHandler(.internalError)
                return
            }
            DispatchQueue.main.async { completionHandler(containers) }
        }, errorHandler: errorHandler)
    }
    
    static func getContainer(id: Int,
                             completionHandler: @escaping (Container) -> Void,
                             errorHandler: @escaping (APIError) -> Void) {
        guard let request = URLRequest(url: API.containers.url.appending("\(id)"), type: .GET) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { data in
            guard let container = try? JSONDecoder().decode(Container.self, from: data) else {
                errorHandler(.internalError)
                return
            }
            DispatchQueue.main.async { completionHandler(container) }
        }, errorHandler: errorHandler)
    }
    
    static func createContainer(name: String,
                                type: String,
                                completionHandler: @escaping () -> Void,
                                errorHandler: @escaping (APIError) -> Void) {
        let postContent = ["name": name, "type": type]
        guard let request = URLRequest(url: API.containers.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { _ in
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    static func updateContainer(id: Int,
                                name: String,
                                type: String,
                                completionHandler: @escaping () -> Void,
                                errorHandler: @escaping (APIError) -> Void) {
        let postContent = ["name": name, "type": type]
        guard let request = URLRequest(url: API.containers.url.appending("\(id)"), content: postContent, type: .PUT) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { _ in
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    static func deleteContainer(id: Int,
                                completionHandler: @escaping () -> Void,
                                errorHandler: @escaping (APIError) -> Void) {
        guard let request = URLRequest(url: API.containers.url.appending("\(id)"), type: .DELETE) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { _ in
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
    
    
    
    
    
    static func addItem(container: Int,
                        name: String,
                        brand: String?=nil,
                        expiration: Date?=nil,
                        calories: Int?=nil,
                        quantity: Int?=nil,
                        completionHandler: @escaping () -> Void,
                        errorHandler: @escaping (APIError) -> Void) {
        var postContent: [String: Encodable] = [
            "container_id": container,
            "name": name
        ]
        
        if let brand = brand {
            postContent["brand"] = brand
        }
        if let expiration = expiration {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            postContent["expiration"] = formatter.string(from: expiration)
        }
        if let calories = calories {
            postContent["calories"] = calories
        }
        if let quantity = quantity {
            postContent["quantity"] = quantity
        }
        
        guard let request = URLRequest(url: API.item.url, content: postContent, type: .POST) else {
            errorHandler(.internalError)
            return
        }
        request.getJsonData(completionHandler: { _ in
            DispatchQueue.main.async { completionHandler() }
        }, errorHandler: errorHandler)
    }
}
