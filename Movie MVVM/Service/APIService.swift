//
//  APIService.swift
//  Movie MVVM
//
//  Created by Lai Min Hou on 23/11/2020.
//  Copyright © 2020 IngLab. All rights reserved.
//

import UIKit

protocol APIServiceProtocol {
    func getMovieList(title: String, page: Int, completion: @escaping(Bool, MovieSearchModel?, Error?) ->())
    func getMovieDetail(id: String, completion: @escaping(Bool, MovieModel?, Error?) ->())
}

class APIService: APIServiceProtocol {
    private let baseURL = "https://www.omdbapi.com/?apikey=b9bd48a6"
    
    func getMovieList(title: String, page: Int, completion: @escaping(Bool, MovieSearchModel?, Error?) ->()) {
        let url = baseURL + "&s=\(title)&type=movie&page=\(page)"
        let sourceURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        URLSession.shared.dataTask(with: sourceURL!) { (data, urlResponse, error) in
            if let error = error {
                completion(false, nil, error)
            }
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let movieList = try! jsonDecoder.decode(MovieSearchModel.self, from: data)
                completion(true, movieList, nil)
            }
        }.resume()
    }
    
    func getMovieDetail(id: String, completion: @escaping(Bool, MovieModel?, Error?) ->()) {
        let url = baseURL + "&i=\(id)"
        let sourceURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        URLSession.shared.dataTask(with: sourceURL!) { (data, urlResponse, error) in
            if let error = error {
                completion(false, nil, error)
            }
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let movieDetail = try! jsonDecoder.decode(MovieModel.self, from: data)
                completion(true, movieDetail, nil)
            }
        }.resume()
    }
}
