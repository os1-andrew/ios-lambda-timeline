//
//  PostDetailView.swift
//  LambdaTimeline
//
//  Created by Andrew Dhan on 10/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation

class PostDetailView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = UIStackView(arrangedSubviews: [titleLabel,authorLabel,locationLabel
            ])
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    //MARK: - Private Methods
    private func updateSubviews(){
        guard let post = post, let geoTag = post.geoTag else {return}
        titleLabel.text = post.title
        authorLabel.text = post.author.displayName
        
        
        let location = CLLocation(latitude: geoTag.latitude, longitude: geoTag.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error{
                NSLog("Error: \(error)")
                return
            }
            guard let placemark = placemarks?.first else {return}
            
            DispatchQueue.main.async {
                self.locationLabel.text = placemark.locality
            }
        }
        
    }
    
    //MARK: - Properties
    var post: Post? {
        didSet{
            updateSubviews()
        }
    }
    var titleLabel = UILabel()
    var authorLabel = UILabel()
    var locationLabel = UILabel()
    private let geocoder = CLGeocoder()
}
