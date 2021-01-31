//
//  LoginResponse.swift
//  goarena-poc
//
//  Created by serhat akalin on 31.01.2021.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable, Equatable {
    let token: String?
    let expireDate: String?

    enum CodingKeys: String, CodingKey {
        case token = "token"
        case expireDate = "expireDate"
    }
}
