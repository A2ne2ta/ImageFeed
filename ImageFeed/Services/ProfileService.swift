//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Анна on 28.01.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var profile: Profile?

    func fetchProfile(authToken: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else {return}
        
        guard let request = makeRequest(token: authToken, path: "/me") else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    let profile = Profile(result: profile)
                    self.profile = profile
                    completion(.success(self.profile!))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.task = nil
                }
        }
        self.task = task
        task.resume()
        
    }
}

extension ProfileService {
    private func makeRequest(token: String, path: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: "GET", baseURL: ApiConstants.defaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(result: ProfileResult) {
        self.username = result.username
        self.name = [result.firstName ?? "", result.lastName ?? ""].joined(separator: " ")
        self.loginName = "@" + self.username
        self.bio = result.bio
    }
}

struct ProfileResult: Decodable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}
    

