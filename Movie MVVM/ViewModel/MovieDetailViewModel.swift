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
    let apiService: APIServiceProtocol
    var alertMessage: String? {
        didSet {
            self.showAlert?()
        }
    }
    var showAlert: (()->())?
    
    fileprivate(set) var movie: MovieModel?
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func retrieveMovieDetail(id: String) {
        apiService.getMovieDetail(id: id) { (success, result, error) in
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                if let result = result {
                    self.movie = result
                    self.delegate?.didLoadDetail()
                }
            }
        }
    }
}
