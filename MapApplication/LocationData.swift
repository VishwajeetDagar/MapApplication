//
//  LocationData.swift
//  MapApplication
//
//  Created by Vishwajeet Dagar on 1/18/17.
//  Copyright © 2017 Vishwajeet. All rights reserved.
//

import MapKit

class LocationData: NSObject,MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        
        self.coordinate=coordinate
        self.title=title
        super.init()
        
    }
    
   static func makeLocationData(result:[String:AnyObject])->LocationData?{
        if let geom = result["geometry"] as? [String:AnyObject] {
            if let locat = geom["location"] as? [String: AnyObject]{
                let loc=LocationData(title: result["name"] as! String,coordinate:CLLocationCoordinate2DMake(locat["lat"] as! CLLocationDegrees, locat["lng"] as! CLLocationDegrees))
                return loc
            }
            else{
                return nil
            }
        }
        else{
            return nil
        }
    }       
}
