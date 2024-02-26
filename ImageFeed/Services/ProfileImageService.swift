//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Анна on 29.01.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else {return}
        
        guard let token = OAuth2TokenStorage.shared.token else {
            fatalError("Failed to get token")
        }
        
        guard let request = makeRequest(token: token, path: "/users/\(username)") else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let avatarURL = body.profileImage.large
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                
            case .failure(let error):
                self.task = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileImageService {
    private func makeRequest(token: String, path: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: "GET", baseURL: ApiConstants.defaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
