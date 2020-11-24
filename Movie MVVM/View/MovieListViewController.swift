//
//  MovieListViewController.swift
//  Movie MVVM
//
//  Created by Lai Min Hou on 23/11/2020.
//  Copyright © 2020 IngLab. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    fileprivate let model = MovieListViewModel()
    // MARK: - Collection View Properties
    private let reuseIdentifier = "MovieCell"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let margin: CGFloat = 10
    
    var privateList = [MovieModel]()
    var fromPage = 0

    @IBOutlet weak var cvMovie: UICollectionView!
    @IBOutlet weak var textFieldSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSearch.delegate = self
        cvMovie.dataSource = self
        cvMovie.delegate = self
        cvMovie.register(UINib.init(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        model.delegate = self
        setupUI()
        
    }
    
    private func setupUI() {
        navigationItem.backButtonTitle = ""

        
        guard let collectionView = cvMovie, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        model.retrieveMovie(title: textFieldSearch.text ?? "")
    }
}

extension MovieListViewController: MovieListViewModelProtocol {
    func didFetchMovies() {
        DispatchQueue.main.async {
            self.model.movie?.search?.forEach{
                self.privateList.append($0)
            }
            self.cvMovie.reloadData()
        }
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return model.movie?.search?.count ?? 0
        return privateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        cell.configure(with: privateList[indexPath.row])
        
        if indexPath.row == privateList.count - 1 {
            fromPage = fromPage + 1
            model.retrieveMovie(title: textFieldSearch.text ?? "", page: fromPage)
        }
        return cell
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "movieDetail") as! MovieDetailViewController
        detailVC.movieId = privateList[indexPath.row].imdbID
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(itemsPerRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(itemsPerRow))

        return CGSize(width: size, height: size)
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//      return sectionInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//      return sectionInsets.left
//    }
}

extension MovieListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fromPage = 0
        privateList.removeAll()
        fromPage = fromPage + 1
        model.retrieveMovie(title: textField.text ?? "", page: fromPage)
        textField.resignFirstResponder()
        return true
    }
}
