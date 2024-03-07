//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Анна on 05.03.2024.
//

import Foundation
import WebKit

public protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func prepareAlert() -> UIAlertController
    func getImageURL() -> URL?
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar()
            }
        view?.updateAvatar()
    }
    
    func prepareAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(
            title: "Да",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                OAuth2TokenStorage().token = nil
                HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
                WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                    records.forEach { record in
                        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    }
                }
                guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
                window.rootViewController = SplashViewController()
            }
        
        let deleteAction = UIAlertAction(
            title: "Нет",
            style: .default) { _ in
                alert.dismiss(animated: true)
            }
        
        alert.addAction(acceptAction)
        alert.addAction(deleteAction)
        return alert
    }
    
    func getImageURL() -> URL? {
        if let imageURL = ProfileImageService.shared.avatarURL,
           let avatarURL = URL(string: imageURL) {
            return avatarURL
        } else {
            return nil
        }
    }
}



