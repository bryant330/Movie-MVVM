//
//  MovieDetailViewModelTests.swift
//  Movie MVVMTests
//
//  Created by Lai Min Hou on 24/11/2020.
//  Copyright © 2020 IngLab. All rights reserved.
//

import XCTest
@testable import Movie_MVVM


class MovieDetailViewModelTests: XCTestCase {
    
    var sut: MovieDetailViewModel!
    var mockAPIService: MockApiService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockApiService()
        sut = MovieDetailViewModel(apiService: mockAPIService)
    }

    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }

    func test_fetch_movie_detail() {
        // Given
        mockAPIService.completeMovieDetail = StubGenerator().stubMovieDetail()

        // When
        sut.retrieveMovieDetail(id: "test")

        // Assert
        XCTAssert(mockAPIService!.isGetMovieDetailCalled)
    }

    func test_fetch_movie_detail_fail() {

        // Given a failed fetch with a certain failure
        let error: Error = AppError.network(type: .custom(errorCode: 400, errorDescription: "Bad request"))

        // When
        sut.retrieveMovieDetail(id: "test")

        mockAPIService.detailFetchFail(error: error)

        // Sut should display predefined error message
        XCTAssertEqual( sut.alertMessage, error.localizedDescription )
    }

}
