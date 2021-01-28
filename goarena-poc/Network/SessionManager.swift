//
//  SessionManager.swift
//  goarena-poc
//
//  Created by serhat akalin on 28.01.2021.
//

import Foundation

class SessionManager {
    
    static let shared = SessionManager()
    private init() {}
    
    var uid: String?
    var token: String?
    
    func startSession() {
        uid = generateUid()
        token = generateToken()
    }
    
    func endSession() {
        uid = nil
        token = nil
    }
    
    private func generateToken() -> String {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return "" }

        let timeInterval = Date().timeIntervalSince1970
        let input = bundleIdentifier + ":" + String(Int(timeInterval))

        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._:"
        let key = "Btc4022Xrp0.36Eth113Str0.15"

        var j = 0
        var output = ""

        for i in 0 ..< input.count {

            let inputIndex = input.index(input.startIndex, offsetBy: i)
            let characterIndexFromInput = characters.firstIndex(of: input[inputIndex])

            let keyIndex = key.index(key.startIndex, offsetBy: j)
            let characterIndexFromKey = characters.firstIndex(of: key[keyIndex])

            let characterIndex = characters.index(characters.startIndex, offsetBy: (characterIndexFromInput!.utf16Offset(in: input) + characterIndexFromKey!.utf16Offset(in: key)) % characters.count)
            output.append(characters[characterIndex])
            j = (j + 1) % key.count
        }

        return output
        
    }
    
    private func generateUid() -> String {
        let length = 150
        let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
