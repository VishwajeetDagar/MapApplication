//
//  NetworkUtil.swift
//  MapApplication
//
//  Created by Vishwajeet Dagar on 1/18/17.
//  Copyright © 2017 Vishwajeet. All rights reserved.
//

import UIKit
import MapKit

class NetworkUtil{

    func queryGooglePlaces(url:URL,networkClosure: @escaping (_ data: Data?)->()){
        
            let request=URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if error != nil
                {
                    print("Error trying to connect to internet.")
                }
                networkClosure(data)
            }
            task.resume()
    }
}
