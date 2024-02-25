//
//  ProfileImageResponceModel.swift
//  ImageFeed
//
//  Created by Анна on 29.01.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImageUrl
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profileImage"
    }
}

struct ProfileImageUrl: Codable {
    let small: String
    let medium: String
    let large: String
    
    enum CodingKeys: String, CodingKey {
        case small
        case medium
        case large
    }
}
