//
//  MovieDetailViewModel.swift
//  Movie MVVM
//
//  Created by Lai Min Hou on 23/11/2020.
//

import UIKit

protocol MovieDetailViewModelProtocol {
    func didLoadDetail()
}

class MovieDetailViewModel: NSObject {
    var delegate: MovieDetailViewModelProtocol?
    
    fileprivate(set) var movie: MovieModel?
    
    private var service = APIService()
    
    func retrieveMovieDetail(id: String) {
        service.getMovieDetail(id: id) { (result, error) in
            if let error = error {
                print(error)
            } else {
                if let result = result {
                    self.movie = result
                    self.delegate?.didLoadDetail()
                }
            }
        }
    }
}
