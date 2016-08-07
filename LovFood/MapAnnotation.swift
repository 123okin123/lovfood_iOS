//
//  MapAnnotation.swift
//  LovFood
//
//  Created by Nikolai Kratz on 27.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    let title: String?
    var subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?

    var cookingEvent: CookingEvent?
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, image: UIImage?, cookingEvent : CookingEvent?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.image = image
        self.cookingEvent = cookingEvent

        
        super.init()
    }
    
    
}
