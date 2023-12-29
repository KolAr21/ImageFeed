//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Арина Колганова on 29.12.2023.
//

import XCTest

class ImageFeedUITests: XCTestCase {
    private let login = ""
    private let password = ""
    private let lastName = ""
    private let username = "@"
    private let app = XCUIApplication() // переменная приложения

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 2))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(login)
        webView.swipeUp()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(password)
        webView.swipeUp()

        webView.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)

        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        cellToLike.buttons["likeButton"].tap()
        sleep(2)

        cellToLike.tap()
        sleep(2)

        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["back"]
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts[lastName].exists)
        XCTAssertTrue(app.staticTexts[username].exists)

        app.buttons["logoutButton"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
