//
//  MovieListViewModel.swift
//  Movie MVVM
//
//  Created by Lai Min Hou on 23/11/2020.
//

import UIKit


protocol MovieListViewModelProtocol {
    func didFetchMovies()
}

class MovieListViewModel: NSObject {
    var delegate: MovieListViewModelProtocol?
    let apiService: APIServiceProtocol
    var alertMessage: String? {
        didSet {
            self.showAlert?()
        }
    }
    var showAlert: (()->())?
    
    fileprivate(set) var movie: MovieSearchModel?
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func retrieveMovie(title: String, page: Int) {
        apiService.getMovieList(title: title, page: page) { (success, movieResult, error) in
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                if let result = movieResult {
//                    self.movie?.search?.append(result.search)
                    self.movie = result
                    self.delegate?.didFetchMovies()
                }
            }
        }
    }
}
