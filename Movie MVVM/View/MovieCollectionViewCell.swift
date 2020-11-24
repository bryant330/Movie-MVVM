//
//  MovieCollectionViewCell.swift
//  Movie MVVM
//
//  Created by Lai Min Hou on 23/11/2020.
//  Copyright © 2020 IngLab. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottomView.backgroundColor = .clear

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bottomView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bottomView.insertSubview(blurEffectView, belowSubview: lblYear)
    }
    
    public func configure(with model: MovieModel?) {
        imageView.kf.setImage(with: URL(string: model?.poster ?? ""), placeholder: UIImage(named: "icon-placeholder"))
        lblYear.text = model?.year ?? ""
        lblTitle.text = model?.title ?? ""
    }
}
