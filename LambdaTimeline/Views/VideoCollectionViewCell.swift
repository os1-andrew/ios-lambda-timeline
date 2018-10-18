//
//  VideoCollectionViewCell.swift
//  LambdaTimeline
//
//  Created by Andrew Dhan on 10/17/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLabelBackgroundView()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        imageView.image = nil
        titleLabel.text = ""
        authorLabel.text = ""
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        titleLabel.text = post.title
        authorLabel.text = post.author.displayName
    }
    
    func setupLabelBackgroundView() {
        labelBackgroundView.layer.cornerRadius = 8
        //        labelBackgroundView.layer.borderColor = UIColor.white.cgColor
        //        labelBackgroundView.layer.borderWidth = 0.5
        labelBackgroundView.clipsToBounds = true
    }
    
    func setImage(_ image: UIImage?) {
        
    }
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }

    
    @IBOutlet weak var labelBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
}
