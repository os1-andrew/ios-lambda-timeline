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
        updateAnnotations()
    }
    
    //MARK: - MKMapViewDelegeMethods
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        updateAnnotations()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let post = annotation as? Post,
            let result = mapView.dequeueReusableAnnotationView(withIdentifier: "PostAnnotationView", for: annotation) as? MKMarkerAnnotationView else {return nil}
        result.canShowCallout = true
        let detailView = PostDetailView(frame: .zero)
        result.detailCalloutAccessoryView = detailView
        detailView.post = post
        
        return result
    }
    //MARK: - Private Methods
    private func updateAnnotations(){
        mapView.addAnnotations(geoTaggedPosts)
    }

    //MARK: - Properties
    let postController = PostController.shared
    var geoTaggedPosts = [Post]()
    
    @IBOutlet weak var mapView: MKMapView!
}
