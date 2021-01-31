//
//  File.swift
//  goarena-poc
//
//  Created by serhat akalin on 31.01.2021.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private var key = "kToken"
    var token: String?

    init() { }

    func initialize() {
        token = get()
    }


    func save(_ t: String?) {
        UserDefaults.standard.set(t, forKey: key)
        token = t
    }
    
    func get() -> String {
        if let token = UserDefaults.standard.string(forKey: key) {
            return token
        }
        return token ?? ""
    }
}
