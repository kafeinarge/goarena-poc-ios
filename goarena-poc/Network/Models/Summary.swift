//
//  Summary.swift
//  goarena-poc
//
//  Created by serhat akalin on 30.01.2021.
//

import Foundation

// MARK: - Summary
struct Summary: Codable, Equatable {
    let content: [SumContent]
    let pageable: Pageable
    let last: Bool?
    let totalPages: Int?
    let totalElements: Int?
    let sort: Sort?
    let first: Bool?
    let numberOfElements: Int?
    let size: Int?
    let number: Int?
    let empty: Bool?

    enum CodingKeys: String, CodingKey {
        case content = "content"
        case pageable = "pageable"
        case last = "last"
        case totalPages = "totalPages"
        case totalElements = "totalElements"
        case sort = "sort"
        case first = "first"
        case numberOfElements = "numberOfElements"
        case size = "size"
        case number = "number"
        case empty = "empty"
    }
}

// MARK: - Content
struct SumContent: Codable, Equatable {
    let user: User?
    let paidCount: Int?
    let unpaidCount: Int?
    let totalGoal: Int?
    let year: Int?
    let month: Int?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case user = "user"
        case paidCount = "paidCount"
        case unpaidCount = "unpaidCount"
        case totalGoal = "totalGoal"
        case year = "year"
        case month = "month"
        case category = "category"
    }
}

