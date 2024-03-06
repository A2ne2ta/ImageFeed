//
//  ProfileViewPresenterSky.swift
//  Image FeedTests
//
//  Created by Анна on 05.03.2024.
//
import ImageFeed
import Foundation
import UIKit

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var prepareAlertCalled: Bool = false
    var updateAvatar: Bool = false
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func prepareAlert() -> UIAlertController {
        prepareAlertCalled = true
        return UIAlertController()
    }
    
    func getImageURL() -> URL? {
        updateAvatar = true
        
        return nil
    }
    
}

