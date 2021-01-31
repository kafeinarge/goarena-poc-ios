//
//  LoginAPI.swift
//  goarena-poc
//
//  Created by serhat akalin on 31.01.2021.
//

import Foundation
import Alamofire

class LoginAPI {
    func login(lockScreen: Bool,
                        username: String,
                        password: String,
                        succeed: @escaping (LoginResponse) -> Void,
                         failed: @escaping (ErrorMessage) -> Void) {
        var headerParams = HTTPHeaders()
        headerParams.add(name: "Content-Type", value: "application/json")
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        
        BaseAPI.shared.request(methotType: .post,
                               params: parameters,
                               baseURL: URLs.loginURL.rawValue,
                               urlPath: Endpoint.login.rawValue,
                               lockScreen: lockScreen,
                               succeed: succeed,
                               failed: failed)
    }
}
