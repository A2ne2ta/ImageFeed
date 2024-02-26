//
//  Constants.swift
//  ImageFeed
//
//  Created by Анна on 03.01.2024.
//

import Foundation


enum ApiConstants {
    static let accessKey = "WJal3OeE8e5pg4WNIFhkqRE2vsvZU2fODTUlmek-1bk"
    static let secretKey = "8-u2PmwzQvV6FvSy6ClcGN2GE5U7292qXQT635AG6o4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let authURL = "https://unsplash.com/oauth/authorize"
}
