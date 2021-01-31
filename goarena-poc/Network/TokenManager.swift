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
    private var kUser = "kUser"
    var token: String?
    var userId: Int?

    init() { }

    func initialize() {
        token = get()
        userId = getUser()
    }

    func save(_ t: String?) {
        UserDefaults.standard.set(t, forKey: key)
        token = t
    }

    func saveUser(_ t: Int?) {
        UserDefaults.standard.set(t, forKey: kUser)
        userId = t
    }

    func get() -> String {
        if let token = UserDefaults.standard.string(forKey: key) {
            return token
        }
        return token ?? ""
    }

    func getUser() -> Int {
        return UserDefaults.standard.integer(forKey: kUser)
    }
}
