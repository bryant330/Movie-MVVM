//
//  APIServiceTests.swift
//  Movie MVVMTests
//
//  Created by Lai Min Hou on 24/11/2020.
//  Copyright © 2020 IngLab. All rights reserved.
//

import XCTest
@testable import Movie_MVVM

class APIServiceTests: XCTestCase {
    
    var sut: APIService?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = APIService()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
        
    func test_fetch_movie_list() {
        // Given A apiservice
        let sut = self.sut!

        // When fetch movie list
        let expect = XCTestExpectation(description: "callback")

        sut.getMovieList(title: "Marvel", page: 1) { (success, model, error) in
            expect.fulfill()
            XCTAssertEqual(model?.search?.count, 10)
            model?.search?.forEach{
                XCTAssertNotNil($0.imdbID)
            }
        }

        wait(for: [expect], timeout: 2)
    }

}
