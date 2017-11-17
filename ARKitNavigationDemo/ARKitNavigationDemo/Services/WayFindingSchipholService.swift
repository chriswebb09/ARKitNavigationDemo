//
//  WayFIndingSchipholService.swift
//  ARKitNavigationDemo
//
//  Created by Ben Smith on 17/11/2017.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
class WayFindingSchipholService{
    
    public static func parseRout() {
        let routeSchipolLocal = Bundle.main.url(forResource: "routeSchiphol", withExtension: "json")
        do {
            let data = try String.init(contentsOf: routeSchipolLocal!)
            let decoder = JSONDecoder()
            let schipholRoutes = try! decoder.decode(Json4Swift_Base.self,
                                                     from: data.data(using: .utf8)!)
            print(schipholRoutes)
            //            Json4Swift_Base.init(from: decoder as! Decoder)
            //            if let dict = json as? NSDictionary {
            //                print(dict)
            //                Json4Swift_Base.init(from: schipholRoutes)
            //            }
        }
        catch {
            //Handle error
            
        }
        
        //        Alamofire.request(routeSchipolLocal!,
        //                          method: .get,
        //                          parameters: nil,
        //                          encoding: JSONEncoding.default).responseJSON { (response) in
        //                            switch response.result {
        //                            case .success(let jsonData):
        //                                break
        //
        //                            case .failure(let error):
        //                                print("error \(error)")
        //                            }
        //        }
        
    }
}
