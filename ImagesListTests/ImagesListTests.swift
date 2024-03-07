//
//  ImagesListTests.swift
//  Image FeedTests
//
//  Created by Анна on 05.03.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        _ = viewController.view
        
        // when
        viewController.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testImagesListUpdateListModel() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        presenter.view = viewController
        _ = viewController.view
        viewController.presenter = presenter
        
        //when
        viewController.updateTableViewAnimated()
        
        //then
        XCTAssertTrue(presenter.updateListModelCalled)
    }
    
    func testImagesListConvertData() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        
        let photo = Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: nil, welcomeDescription: "", thumbImageURL: "", largeImageURL: "", isLiked: false)
        
        //when
        _ = viewController.convertDataFromPhoto(photo: photo)
        
        //then
        XCTAssertTrue(presenter.convertDataCalled)
    }
    
    func testPresenterConvertDate() {
        //given
        let presenter = ImagesListPresenter()
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(year: 2024, month: 3, day: 5))
        let photo = Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: date, welcomeDescription: "Hello", thumbImageURL: "", largeImageURL: "", isLiked: false)
        
        //when
        let stringDate = presenter.convertData(photo: photo)
        
        //then
        XCTAssertEqual(stringDate, "05 марта 2024")
    }
    
}
