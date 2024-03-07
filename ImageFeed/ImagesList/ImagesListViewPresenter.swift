//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Анна on 04.03.2024.
//

import Foundation
import UIKit

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func viewDidLoad()
    func getNewPhotos(photoNumber: Int)
    func convertData(photo: Photo) -> String
    func updateListModel() -> [IndexPath]?
    func calculateImageHeight(index: Int, imageViewWidth: CGFloat) -> CGFloat
    func changeLike(index: Int, cell: ImagesListCell)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private let imageListService = ImagesListService.shared
    var photos: [Photo] = []
    private var photoServiceObserver: NSObjectProtocol?
    
    weak var view: ImagesListViewControllerProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func viewDidLoad() {
        photoServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateTableViewAnimated()
            })
        
        if (photos.isEmpty) {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    func getNewPhotos(photoNumber: Int) {
        if photoNumber + 1 == imageListService.photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    func convertData(photo: Photo) -> String {
        return photo.createdAt == nil ? "" : dateFormatter.string(from: photo.createdAt!)
    }
    
    func updateListModel() -> [IndexPath]? {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            let newIndexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            return newIndexPaths
        }
        return nil
    }
    
    func calculateImageHeight(index: Int, imageViewWidth: CGFloat) -> CGFloat {
        let image = photos[index]
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let imageHeight = image.size.height * scale
        return imageHeight
    }
    
    func changeLike(index: Int, cell: ImagesListCell) {
        let photo = photos[index]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos[index].isLiked.toggle()
                cell.setIsLiked(isLiked: self.photos[index].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
