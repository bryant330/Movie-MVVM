//
//  MovieListViewModelTests.swift
//  Movie MVVMTests
//
//  Created by Lai Min Hou on 24/11/2020.
//  Copyright © 2020 IngLab. All rights reserved.
//

import XCTest
@testable import Movie_MVVM

class MovieListViewModelTests: XCTestCase {
    
    var sut: MovieListViewModel!
    var mockAPIService: MockApiService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockApiService()
        sut = MovieListViewModel(apiService: mockAPIService)
    }

    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }

    func test_fetch_movie_list() {
        // Given
        mockAPIService.completeMovieList = StubGenerator().stubMovies()

        // When
        sut.retrieveMovie(title: "marvel", page: 1)

        // Assert
        XCTAssert(mockAPIService!.isGetMoviesCalled)
    }
    
    func test_fetch_movie_list_fail() {

        // Given a failed fetch with a certain failure
        let error: Error = AppError.network(type: .custom(errorCode: 400, errorDescription: "Bad request"))

        // When
        sut.retrieveMovie(title: "marvel", page: 1)

        mockAPIService.fetchFail(error: error)

        // Sut should display predefined error message
        XCTAssertEqual( sut.alertMessage, error.localizedDescription )

    }

}


