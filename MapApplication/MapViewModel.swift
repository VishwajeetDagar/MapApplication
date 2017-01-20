//
//  MapViewModel.swift
//  MapApplication
//
//  Created by Vishwajeet Dagar on 1/18/17.
//  Copyright © 2017 Vishwajeet. All rights reserved.
//

import Foundation
import MapKit

class MapViewModel{

    init(){}
    var st: [LocationData] = [LocationData]()
    let Google_API_key = "AIzaSyCeqkrSZWwafNvYw0GoSqKhUW7txeV4W74"
    let radi=2500
    
    func getAnnot(annotation: MKAnnotation)->LocationData?{
        if let annotation = annotation as? LocationData {
            return annotation
        }
        return nil
    }
    
    func giveLocation(annotation:MKAnnotation)->String{
    let annot=annotation as! LocationData
        return annot.title!
    }
    
    func getRestaurants(currentLocation: CLLocationCoordinate2D, completionClosure: @escaping (_ restaurantLocation: [LocationData]?)->()){
        let url=URL(string: "https://maps.googleapis.com/maps/api/place/search/json?location=\(currentLocation.latitude),\(currentLocation.longitude)&radius=\(radi)&types=restaurant&sensor=true&key=\(Google_API_key)")

        NetworkUtil().queryGooglePlaces(url: url!,networkClosure: {(data :Data?)->() in
            do{
                if data != nil {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] {
                    if let results = convertedJsonIntoDict["results"] as? [[String:AnyObject]]  {
                        for result in results{
                            if let loc=LocationData.makeLocationData(result: result){
                                self.st.append(loc)
                            }
                            else{
                                print("Could not obtain location")
                            }
                        }
                    }
                    else{
                        print("Error in data obtained from API")
                    }
                    completionClosure(self.st)
                }
                else{
                    print("Error in data obtained from API")
                }
                }
                else{
                    print("Could not fetch data as network connection is not available")
                    completionClosure(nil)
                }
            }
            catch let error as NSError {
                print("Error found\(error.localizedDescription)")
            }
        })
    }
    
}
