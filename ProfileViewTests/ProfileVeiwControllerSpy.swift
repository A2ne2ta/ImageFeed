//
//  ProfileVeiwControllerSky.swift
//  Image FeedTests
//
//  Created by Анна on 05.03.2024.
//

import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var updateAvatarCalled: Bool = false
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    
}
