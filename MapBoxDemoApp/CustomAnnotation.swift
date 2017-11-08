//
//  CustomAnnotation.swift
//  MapBoxDemoApp
//
//  Created by Sumedh Ravi on 06/11/17.
//  Copyright © 2017 Sumedh Ravi. All rights reserved.
//

import UIKit
import Mapbox
class CustomAnnotation: NSObject, MGLAnnotation{
    
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        
        // Custom properties that we will use to customize the annotation's image.
        
        var reuseIdentifier: String?
    
        
        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        
        }
    
    func shouldChangeRadius(radius: Double){
        
    }
    
}
