//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Анна on 13.02.2024.
//

import Foundation

final class ImagesListService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private var lastLoadedPage: Int = 1
    private let formatter = ISO8601DateFormatter()
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard task == nil else {return}
        let path = "/photos?page=\(lastLoadedPage)"
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: "GET")
        
        guard let token = OAuth2TokenStorage().token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosList):
                DispatchQueue.main.async {
                    for photo in photosList {
                        self.photos.append(Photo(
                            id: photo.id,
                            size: CGSize(width: photo.width, height: photo.height),
                            createdAt: self.convertDate(stringDate: photo.createdAt),
                            welcomeDescription: photo.description ?? "",
                            thumbImageURL: photo.urls.thumb,
                            largeImageURL: photo.urls.full,
                            isLiked: photo.likedByUser))
                        self.task = nil
                        self.lastLoadedPage += 1
                        
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["photos": self.photos])
                    }
                }
            case .failure(let error):
                print(error)
                self.task = nil
            }
        }
        self.task = task
        task.resume()
        
    }
    
    private func convertDate(stringDate: String) -> Date? {
        return stringDate == "" ? Date() : formatter.date(from: stringDate)
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard task == nil else {return}
        let method = isLike ? "POST" : "DELETE"
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/"
            + "\(photoId)"
            + "/like",
            httpMethod: "\(method)")
        guard let token = OAuth2TokenStorage().token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let photoResult):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoResult.photo.id }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked)
                        self.photos[index] = newPhoto
                    }
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
