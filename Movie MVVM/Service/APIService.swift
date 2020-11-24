//
//  APIService.swift
//  Movie MVVM
//
//  Created by Lai Min Hou on 23/11/2020.
//  Copyright © 2020 IngLab. All rights reserved.
//

import UIKit

class APIService: NSObject {
    private let baseURL = "https://www.omdbapi.com/?apikey=b9bd48a6"
    
    func getMovieList(title: String, page: Int, completion: @escaping(MovieSearchModel?, Error?) ->()) {
        let url = baseURL + "&s=\(title)&type=movie&page=\(page)"
        let sourceURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        URLSession.shared.dataTask(with: sourceURL!) { (data, urlResponse, error) in
            if let error = error {
                completion(nil, error)
            }
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let movieList = try! jsonDecoder.decode(MovieSearchModel.self, from: data)
                completion(movieList, nil)
            }
        }.resume()
    }
    
    func getMovieDetail(id: String, completion: @escaping(MovieModel?, Error?) ->()) {
        let url = baseURL + "&i=\(id)"
        let sourceURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        URLSession.shared.dataTask(with: sourceURL!) { (data, urlResponse, error) in
            if let error = error {
                completion(nil, error)
            }
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let movieDetail = try! jsonDecoder.decode(MovieModel.self, from: data)
                completion(movieDetail, nil)
            }
        }.resume()
    }
}
