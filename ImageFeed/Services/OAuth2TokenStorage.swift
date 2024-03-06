//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Анна on 04.01.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let keychain = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychain.string(forKey: Keys.token.rawValue)
        }

        set {
            if newValue == nil {
                keychain.removeObject(forKey: Keys.token.rawValue)
            } else {
                keychain.set(newValue!, forKey: Keys.token.rawValue)
            }
        }
    }
    
    public func clear() {
        keychain.removeObject(forKey: Keys.token.rawValue)
    }
    
    private enum Keys: String {
        case token
    }
}
