//
//  Wall.swift
//  goarena-poc
//
//  Created by serhat akalin on 27.01.2021.
//

import Foundation

// MARK: - WallResponse
struct WallResponse: Codable, Equatable {
    let content: [Content]
    let pageable: Pageable
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let sort: Sort
    let numberOfElements: Int
    let first: Bool
    let size: Int
    let number: Int
    let empty: Bool

    enum CodingKeys: String, CodingKey {
        case content = "content"
        case pageable = "pageable"
        case totalPages = "totalPages"
        case totalElements = "totalElements"
        case last = "last"
        case sort = "sort"
        case numberOfElements = "numberOfElements"
        case first = "first"
        case size = "size"
        case number = "number"
        case empty = "empty"
    }
}

// MARK: - Content
struct Content: Codable, Equatable {
    let id: Int?
    let userId: Int?
    let user: User?
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

// MARK: - User
struct User: Codable, Equatable {
    let id: Int?
    let name: String?
    let surname: String?
    let username: String?
    let admin: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case surname = "surname"
        case username = "username"
        case admin = "admin"
    }
}

// MARK: - Pageable
struct Pageable: Codable, Equatable {
    let sort: Sort?
    let pageNumber: Int?
    let pageSize: Int?
    let offset: Int?
    let unpaged: Bool?
    let paged: Bool?

    enum CodingKeys: String, CodingKey {
        case sort = "sort"
        case pageNumber = "pageNumber"
        case pageSize = "pageSize"
        case offset = "offset"
        case unpaged = "unpaged"
        case paged = "paged"
    }
}

// MARK: - Sort
struct Sort: Codable, Equatable {
    let sorted: Bool?
    let unsorted: Bool?
    let empty: Bool?

    enum CodingKeys: String, CodingKey {
        case sorted = "sorted"
        case unsorted = "unsorted"
        case empty = "empty"
    }
}

