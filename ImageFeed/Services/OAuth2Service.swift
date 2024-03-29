//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Анна on 04.01.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
    private (set) var authToken: String? {
        get { return OAuth2TokenStorage.shared.token }
        set { OAuth2TokenStorage.shared.token = newValue }
    }
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ){
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    self.lastCode = nil
                    completion(.failure(error))
                }
                
                self.task = nil
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(ApiConstants.accessKey)"
            + "&&client_secret=\(ApiConstants.secretKey)"
            + "&&redirect_uri=\(ApiConstants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        ) }
}
// MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = ApiConstants.defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    } }

