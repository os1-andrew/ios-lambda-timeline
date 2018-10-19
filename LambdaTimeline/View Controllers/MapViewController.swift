//
//  MapViewController.swift
//  LambdaTimeline
//
//  Created by Andrew Dhan on 10/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PostAnnotationView")
        geoTaggedPosts = postController.posts.compactMap{
            $0.geoTag != nil ? $0 : nil
        }
        updateView()
    }
    
    //MARK: - MKMapViewDelegeMethods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let result = mapView.dequeueReusableAnnotationView(withIdentifier: "PostAnnotationView", for: annotation)
        
        return result
    }
    //MARK: - Private Methods
    private func updateView(){
        mapView.addAnnotations(geoTaggedPosts)
    }
    private func updateAnnotationView(for annotation: MKAnnotation){

    }
    //MARK: - Properties
    let postController = PostController.shared
    var geoTaggedPosts = [Post]()
    
    @IBOutlet weak var mapView: MKMapView!
}
