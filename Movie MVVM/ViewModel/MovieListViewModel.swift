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
    
    fileprivate(set) var movie: MovieSearchModel?
    
    private var service = APIService()
    
    func retrieveMovie(title: String, page: Int) {
        service.getMovieList(title: title, page: page) { (movieResult, error) in
            if let error = error {
                print(error)
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
