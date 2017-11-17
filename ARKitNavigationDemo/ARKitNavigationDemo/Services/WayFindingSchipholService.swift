//
//  WayFIndingSchipholService.swift
//  ARKitNavigationDemo
//
//  Created by Ben Smith on 17/11/2017.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import Alamofire
class WayFindingSchipholService{
    
    public static func parseRout() {
        let routeSchipolLocal = Bundle.main.url(forResource: "routeSchiphol", withExtension: "json")

        Alamofire.request(routeSchipolLocal!,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default).responseJSON { (response) in
                            switch response.result {
                            case .success(let jsonData):
                                if let dict = jsonData as? NSDictionary,
                                let routes = dict["routes"] as? NSDictionary,
                                let features = routes["features"] as? NSArray,
                                let feature = features[0] as? NSDictionary,
                                let geometry = feature["geometry"] as? NSDictionary,
                                let paths = geometry["paths"] as? NSArray{
                                    print(paths)
                                }
                                break

                            case .failure(let error):
                                print("error \(error)")
                            }
        }
        
    }
}
