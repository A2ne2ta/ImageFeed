//
//  ImagesListPresenterSpy.swift
//  Image FeedTests
//
//  Created by Анна on 05.03.2024.
//

import ImageFeed
import Foundation

final  class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var photos: [ImageFeed.Photo] = []
    
    var viewDidLoadCalled: Bool = false
    var updateListModelCalled: Bool = false
    var convertDataCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getNewPhotos(photoNumber: Int) {
        
    }
    
    func convertData(photo: ImageFeed.Photo) -> String {
        convertDataCalled = true
        return ""
    }
    
    func updateListModel() -> [IndexPath]? {
        updateListModelCalled = true
        return nil
    }
    
    func calculateImageHeight(index: Int, imageViewWidth: CGFloat) -> CGFloat {
        0.0
    }
    
    func changeLike(index: Int, cell: ImageFeed.ImagesListCell) {
        
    }
    
    
}
