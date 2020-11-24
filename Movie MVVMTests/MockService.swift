//
//  MockService.swift
//  Movie MVVMTests
//
//  Created by Lai Min Hou on 24/11/2020.
//  Copyright © 2020 IngLab. All rights reserved.
//

import Foundation
@testable import Movie_MVVM

class MockApiService: APIServiceProtocol {
    func getMovieList(title: String, page: Int, completion: @escaping (Bool, MovieSearchModel?, Error?) -> ()) {
        isGetMoviesCalled = true
        completeClosure = completion
    }
    
    func getMovieDetail(id: String, completion: @escaping (Bool, MovieModel?, Error?) -> ()) {
        isGetMovieDetailCalled = true
        completeDetailClosure = completion
    }
    
    var isGetMoviesCalled = false
    var isGetMovieDetailCalled = false
    
    var completeMovieList = StubGenerator().stubMovies()
    var completeClosure: ((Bool, MovieSearchModel?, Error?) -> ())!
    var completeMovieDetail = StubGenerator().stubMovieDetail()
    var completeDetailClosure: ((Bool, MovieModel?, Error?) -> ())!
    
    
    func fetchSuccess() {
        completeClosure(true, completeMovieList, nil)
    }
    
    func fetchFail(error: Error?) {
        completeClosure(false, completeMovieList, error)
    }
    
    func detailFetchSuccess() {
        completeDetailClosure(true, completeMovieDetail, nil)
    }
    
    func detailFetchFail(error: Error?) {
        completeDetailClosure(false, completeMovieDetail, error)
    }
    
}

class StubGenerator {
    func stubMovies() -> MovieSearchModel {
        let path = Bundle.main.path(forResource: "response", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let movies = try! decoder.decode(MovieSearchModel.self, from: data)
        return movies
    }
    
    func stubMovieDetail() -> MovieModel {
        let path = Bundle.main.path(forResource: "detailResponse", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let movie = try! decoder.decode(MovieModel.self, from: data)
        return movie
    }
}
