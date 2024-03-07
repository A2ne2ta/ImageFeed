//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Анна on 05.03.2024.
//
@testable import ImageFeed
import XCTest

final class ProfileViewTests:  XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerGetImageURL() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.updateAvatar()
        
        //then
        XCTAssertTrue(presenter.updateAvatar)
    }
    
    func testProfileViewPresenterUpdateAvatar() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
}
