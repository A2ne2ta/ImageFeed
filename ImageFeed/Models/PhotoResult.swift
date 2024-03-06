//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Анна on 13.02.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

enum CodingKeys: String, CodingKey {
    case id, width, height, description, urls
    case createdAt = "created_at"
    case likedByUser = "liked_by_user"
}

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct LikeResult: Decodable {
    let photo: PhotoResult
}

