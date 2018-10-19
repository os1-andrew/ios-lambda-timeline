//
//  PostAnnotation.swift
//  LambdaTimeline
//
//  Created by Andrew Dhan on 10/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import MapKit

extension Post: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let geoTag = self.geoTag else {
            fatalError("No geotag available")
        }
        return geoTag
    }
    
    var subtitle: String? {
        return self.author.displayName
    }
}
