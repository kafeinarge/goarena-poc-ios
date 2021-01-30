//
//  UploadResponse.swift
//  goarena-poc
//
//  Created by serhat akalin on 29.01.2021.
//

import Foundation

// MARK: - UploadResponse
struct UploadResponse: Codable, Equatable {
    let id: Int?
    let userId: Int?
    let user: String?
    let preview: String?
    let text: String?
    let creationDate: String?
    let approval: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "userId"
        case user = "user"
        case preview = "preview"
        case text = "text"
        case creationDate = "creationDate"
        case approval = "approval"
    }
}
