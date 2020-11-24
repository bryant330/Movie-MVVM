//
//  MovieDetailViewController.swift
//  Movie MVVM
//
//  Created by Lai Min Hou on 23/11/2020.
//  Copyright © 2020 IngLab. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    fileprivate let model = MovieDetailViewModel()
    var movieId: String?
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblPlot: UILabel!
    @IBOutlet weak var lblDirector: UILabel!
    @IBOutlet weak var lblWriter: UILabel!
    @IBOutlet weak var lblActor: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var stackViewGenre: UIStackView!
    @IBOutlet weak var lblRated: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblVotes: UILabel!
    @IBOutlet weak var lblMetascore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        model.delegate = self
    }
    
    private func setupUI() {
        self.bottomView.layer.cornerRadius = 30.0
        self.bottomView.layer.masksToBounds = true
    }
    
    @IBAction func playTrailer(_ sender: Any) {
        let youtubeUrl = URL(string:"https://www.youtube.com/results?search_query=\(model.movie?.title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!
        UIApplication.shared.openURL(youtubeUrl)
    }
    private func populateUIDetail() {
        DispatchQueue.main.async { [weak self] in
            let duration = Int.minutesToHoursAndMinutes(Int.parse(from: self?.model.movie?.runtime ?? "0") ?? 0)
            let metascore = Int.parse(from: self?.model.movie?.metascore ?? "0") ?? 0
            let genres = self?.model.movie?.genre?.components(separatedBy: ",")
            genres?.forEach {
                let label = UITextView()
                label.layer.cornerRadius = 15.0
                label.layer.borderWidth = 2.0
                label.layer.borderColor = UIColor.lightGray.cgColor
                label.text = $0
                label.textAlignment = .center
                self?.stackViewGenre.addArrangedSubview(label)
            }

            self?.imageView.kf.setImage(with: URL(string: self?.model.movie?.poster ?? ""))
//            self?.imageView.load(urlString: self?.model.movie?.poster ?? "")
            self?.lblYear.text = self?.model.movie?.year
            self?.lblDuration.text = "\(duration.hours)h " + "\(duration.leftMinutes)min"
            self?.lblRated.text = self?.model.movie?.rated
            self?.lblTitle.text = self?.model.movie?.title
            self?.lblPlot.text = self?.model.movie?.plot
            self?.lblRating.attributedText = NSMutableAttributedString().bold((self?.model.movie?.imdbRating ?? "-")).normal("/10")
            self?.lblMetascore.text = self?.model.movie?.metascore
            if metascore > 0 && metascore < 40 {
                self?.lblMetascore.backgroundColor = UIColor.systemRed
            } else if metascore > 41 && metascore < 80 {
                self?.lblMetascore.backgroundColor = UIColor.systemYellow
            } else if metascore > 81 && metascore < 100 {
                self?.lblMetascore.backgroundColor = UIColor.systemGreen
            }
            self?.lblVotes.text = self?.model.movie?.imdbVotes
            self?.lblDirector.text = "Director: " + (self?.model.movie?.director ?? "")
            self?.lblWriter.text = "Writer: " + (self?.model.movie?.writer ?? "")
            self?.lblActor.text = "Actors: " + (self?.model.movie?.actors ?? "")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.retrieveMovieDetail(id: movieId ?? "")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
    }

}

extension MovieDetailViewController: MovieDetailViewModelProtocol {
    func didLoadDetail() {
        self.populateUIDetail()
    }
}
