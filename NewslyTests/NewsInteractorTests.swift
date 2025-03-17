//
//  NewslyTests.swift
//  NewslyTests
//
//  Created by Nikita Zolotov on 17.03.2025.
//

import XCTest
@testable import Newsly

final class NewsInteractorTests: XCTestCase {
    private var interactor: NewsInteractor!
    private var converter: NewsDTOConverter!
    
    // Mocks
    private var mockPresenter: MockNewsPresenter!
    private var mockWorker: MockNewsWorker!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        converter = NewsDTOConverter()
        mockPresenter = MockNewsPresenter()
        mockWorker = MockNewsWorker()
        
        interactor = NewsInteractor(
            presenter: mockPresenter,
            worker: mockWorker,
            converter: converter
        )
    }

    override func tearDownWithError() throws {
        mockPresenter = nil
        mockWorker = nil
        converter = nil
        interactor = nil
        try super.tearDownWithError()
    }

    func testLoadstart_ClearsArticlesAndCallsRefresh() throws {
        // Arrange
        interactor.articles = [NewsModel.Article(
            id: 1,
            title: "",
            announce: "",
            sourceIcon: nil,
            sourceName: "",
            image: nil
        )]
        let expWorkerCallsCount = 1
        
        // Act
        interactor.loadStart()
    
        // Assert
        XCTAssertTrue(
            interactor.articles.isEmpty,
            "Articles should be cleared"
        )
        XCTAssertEqual(
            mockWorker.fetchNewsCallCount,
            expWorkerCallsCount,
            "fetchNews should be called once"
        )
    }

    func testLoadMoreNews_IncreasesPageAndFetchesNews() throws {
        // Arrange
        let expPageIndex = 1
        
        // Act
        interactor.loadMoreNews()
    
        // Assert
        XCTAssertTrue(
            mockWorker.wasCalled,
            "News wasn't fetched"
        )
        XCTAssertEqual(
            mockWorker.lastFetchRequest?.pageIndex,
            expPageIndex,
            "Should request the next page"
        )
    }
    
    func testRefresh_FailureResponse_CallsPresenterError() {
        // Arrange
        let mockError = NSError(domain: "TestError", code: 500)
        mockWorker.mockResult = .failure(mockError)
        
        // Act
        interactor.refresh()
        
        // Assert
        XCTAssertEqual(mockPresenter.presentErrorCallCount, 1)
    }
    
    func testRefresh_SuccessfulResponse_UpdatesArticles() {
        // Arrange
        let mockNewsDTO = [ArticleDTO(
            id: 2,
            title: "",
            announce: "",
            date: "",
            sourceIcon: "",
            sourceName: "",
            image: nil,
            timeOfReading: "",
            sectionName: ""
        )]
        
        let mockResponse = NewsResponseDTO(news: mockNewsDTO, requestId: "123")
        mockWorker.mockResult = .success(mockResponse)
        
        // Act
        interactor.refresh()
        
        // Assert
        XCTAssertEqual(interactor.articles.count, 1)
        XCTAssertEqual(interactor.articles.first?.id, 2)
    }
}


// MARK: - Mocks
final class MockNewsPresenter: NewsPresentationLogic {
    var presentStartCallCount = 0
    var presentErrorCallCount = 0
    var presentArticlePageCallCount = 0
    var presentSharingCallCount = 0
    
    func presentStart() {
        presentStartCallCount += 1
    }
    
    func presentErrorState(with error: any Error) {
        presentErrorCallCount += 1
    }
    
    func presentArticlePage(with url: URL?) {
        presentArticlePageCallCount += 1
    }
    
    func presentAticleSharingInfo(
        for article: Newsly.NewsModel.Article,
        shareURL: URL?
    ) {
        presentSharingCallCount += 1
    }
}


final class MockNewsWorker: NewsWorkerLogic {
    var wasCalled: Bool = false
    var fetchNewsCallCount = 0
    var lastFetchRequest: NewsModel.FetchRequest?
    var mockResult: Result<Newsly.NewsResponseDTO, any Error>?
    
    func fetchNews(
        for request: Newsly.NewsModel.FetchRequest,
        completion: ((Result<Newsly.NewsResponseDTO, any Error>) -> Void)?
    ) {
        wasCalled = true
        fetchNewsCallCount += 1
        lastFetchRequest = request
        if let result = mockResult {
            completion?(result)
        }
    }
}
