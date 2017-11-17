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
        var routeString = "{\r\n\t\"messages\": [{\r\n\t\t\"type\": 50,\r\n\t\t\"description\": \"Location \\\"Location 1\\\" in \\\"Stops\\\" is on a soft-restricted network element.\"\r\n\t}, {\r\n\t\t\"type\": 50,\r\n\t\t\"description\": \"Location \\\"Location 2\\\" in \\\"Stops\\\" is on a soft-restricted network element.\"\r\n\t}, {\r\n\t\t\"type\": 50,\r\n\t\t\"description\": \"Network elements with avoid-restrictions are traversed in the output (restriction attribute names: \\\"Roadclass 2\\\" \\\"Roadclass 3\\\").\"\r\n\t}],\r\n\t\"checksum\": \"PwkAAAAGAAA.\",\r\n\t\"routes\": {\r\n\t\t\"hasM\": true,\r\n\t\t\"fieldAliases\": {\r\n\t\t\t\"ObjectID\": \"ObjectID\",\r\n\t\t\t\"Name\": \"Name\",\r\n\t\t\t\"FirstStopID\": \"FirstStopID\",\r\n\t\t\t\"LastStopID\": \"LastStopID\",\r\n\t\t\t\"StopCount\": \"StopCount\",\r\n\t\t\t\"Total_PedestrianTime\": \"Total_PedestrianTime\",\r\n\t\t\t\"Shape_Length\": \"Shape_Length\"\r\n\t\t},\r\n\t\t\"geometryType\": \"esriGeometryPolyline\",\r\n\t\t\"spatialReference\": {\r\n\t\t\t\"wkid\": 4326,\r\n\t\t\t\"latestWkid\": 4326\r\n\t\t},\r\n\t\t\"features\": [{\r\n\t\t\t\"attributes\": {\r\n\t\t\t\t\"ObjectID\": 1,\r\n\t\t\t\t\"Name\": \"Location 1 - Location 2\",\r\n\t\t\t\t\"FirstStopID\": 1,\r\n\t\t\t\t\"LastStopID\": 2,\r\n\t\t\t\t\"StopCount\": 2,\r\n\t\t\t\t\"Total_PedestrianTime\": 2.2446090593559886,\r\n\t\t\t\t\"Shape_Length\": 0.0016958535001286132\r\n\t\t\t},\r\n\t\t\t\"geometry\": {\r\n\t\t\t\t\"hasM\": true,\r\n\t\t\t\t\"paths\": [\r\n\t\t\t\t\t[\r\n\t\t\t\t\t\t[4.7623604770000725, 52.309696688000031, 0],\r\n\t\t\t\t\t\t[4.7623490130000619, 52.309702210000069, 0.013258829355239869],\r\n\t\t\t\t\t\t[4.7623386030000461, 52.309694097000033, 0.028571769356727599],\r\n\t\t\t\t\t\t[4.7622142350000445, 52.309597162000046, 0.21151725935935975],\r\n\t\t\t\t\t\t[4.7621481260000564, 52.309545635000063, 0.30876499936580659],\r\n\t\t\t\t\t\t[4.7620932190000644, 52.309502839000061, 0.38953494935035704],\r\n\t\t\t\t\t\t[4.7621424550000597, 52.309479120000049, 0.44647818934917449],\r\n\t\t\t\t\t\t[4.7622582350000471, 52.309423344000038, 0.58038219935894009],\r\n\t\t\t\t\t\t[4.7622988220000479, 52.309234340000046, 0.86319392936229711],\r\n\t\t\t\t\t\t[4.7622148840000591, 52.309168917000079, 0.98666802935600284],\r\n\t\t\t\t\t\t[4.762061362000054, 52.309057597000049, 1.202913469362259],\r\n\t\t\t\t\t\t[4.7619566680000389, 52.309015645000045, 1.3166527893543243],\r\n\t\t\t\t\t\t[4.7617546530000254, 52.308934695000062, 1.5361210793495179],\r\n\t\t\t\t\t\t[4.761632291000069, 52.308886657000073, 1.8903650693655014],\r\n\t\t\t\t\t\t[4.7614207890000557, 52.308811648000074, 2.2446090593576433]\r\n\t\t\t\t\t]\r\n\t\t\t\t]\r\n\t\t\t}\r\n\t\t}]\r\n\t},\r\n\t\"directions\": [{\r\n\t\t\"routeId\": 1,\r\n\t\t\"routeName\": \"Location 1 - Location 2\",\r\n\t\t\"hasM\": true,\r\n\t\t\"summary\": {\r\n\t\t\t\"totalLength\": 141.78371174486949,\r\n\t\t\t\"totalTime\": 2.2446090553421527,\r\n\t\t\t\"totalDriveTime\": 2.2446090593559886,\r\n\t\t\t\"envelope\": {\r\n\t\t\t\t\"xmin\": 4.7594701512693867,\r\n\t\t\t\t\"ymin\": 52.30804349956216,\r\n\t\t\t\t\"xmax\": 4.7623918416973838,\r\n\t\t\t\t\"ymax\": 52.309703099902677,\r\n\t\t\t\t\"spatialReference\": {\r\n\t\t\t\t\t\"wkid\": 4326,\r\n\t\t\t\t\t\"latestWkid\": 4326\r\n\t\t\t\t}\r\n\t\t\t}\r\n\t\t},\r\n\t\t\"features\": [{\r\n\t\t\t\"attributes\": {\r\n\t\t\t\t\"length\": 0,\r\n\t\t\t\t\"time\": 0,\r\n\t\t\t\t\"text\": \"Start at Location 1\",\r\n\t\t\t\t\"ETA\": -2209161600000,\r\n\t\t\t\t\"arriveTimeUTC\": -2209161600000,\r\n\t\t\t\t\"maneuverType\": \"esriDMTDepart\"\r\n\t\t\t},\r\n\t\t\t\"compressedGeometry\": \"+0+1+2+174gnf+5qcusq+1vvf307+0+0|+5rg+0+0\"\r\n\t\t}, {\r\n\t\t\t\"attributes\": {\r\n\t\t\t\t\"length\": 0.99441215552682771,\r\n\t\t\t\t\"time\": 0.013258829355988287,\r\n\t\t\t\t\"text\": \"Go northwest\",\r\n\t\t\t\t\"ETA\": -2209161600000,\r\n\t\t\t\t\"arriveTimeUTC\": -2209161600000,\r\n\t\t\t\t\"maneuverType\": \"esriDMTStraight\"\r\n\t\t\t},\r\n\t\t\t\"compressedGeometry\": \"+0+1+2+174gnf+5qcusq+1vvf307-em+73|+5rg+0+2g\"\r\n\t\t}, {\r\n\t\t\t\"attributes\": {\r\n\t\t\t\t\"length\": 28.220709128449602,\r\n\t\t\t\t\"time\": 0.37627611999999999,\r\n\t\t\t\t\"text\": \"Turn left\",\r\n\t\t\t\t\"ETA\": -2209161600000,\r\n\t\t\t\t\"arriveTimeUTC\": -2209161600000,\r\n\t\t\t\t\"maneuverType\": \"esriDMTTurnLeft\"\r\n\t\t\t},\r\n\t\t\t\"compressedGeometry\": \"+0+1+2+174gnf+5qcue4+1vvf37a-dc-ad-4vg-3sb-2kp-222-26e-1mt|+5rg+2g+2r+12a+i8+f4\"\r\n\t\t}, {\r\n\t\t\t\"attributes\": {\r\n\t\t\t\t\"length\": 35.524423952117665,\r\n\t\t\t\t\"time\": 0.47365897999999995,\r\n\t\t\t\t\"text\": \"Turn left\",\r\n\t\t\t\t\"ETA\": -2209161600000,\r\n\t\t\t\t\"arriveTimeUTC\": -2209161600000,\r\n\t\t\t\t\"maneuverType\": \"esriDMTTurnLeft\"\r\n\t\t\t},\r\n\t\t\t\"compressedGeometry\": \"+0+1+2+174gnf+5qck61+1vver7j+1v5-ud+4kg-27h+1k2-7ie|+5rg+291+am+p3+1l1\"\r\n\t\t}, {\r\n\t\t\t\"attributes\": {\r\n\t\t\t\t\"length\": 77.04416650877539,\r\n\t\t\t\t\"time\": 1.3814151300000006,\r\n\t\t\t\t\"text\": \"Turn right\",\r\n\t\t\t\t\"ETA\": -2209161600000,\r\n\t\t\t\t\"arriveTimeUTC\": -2209161600000,\r\n\t\t\t\t\"maneuverType\": \"esriDMTTurnRight\"\r\n\t\t\t},\r\n\t\t\t\"compressedGeometry\": \"+0+1+2+174gnf+5qcsdo+1vvegf7-3bl-2jt-64t-4ep-469-1lq-833-37q-4su-1tk-8f9-306|+5rg+51r+n5+18h+lb+195+22d+22e\"\r\n\t\t}, {\r\n\t\t\t\"attributes\": {\r\n\t\t\t\t\"length\": 0,\r\n\t\t\t\t\"time\": 0,\r\n\t\t\t\t\"text\": \"Finish at Location 2\",\r\n\t\t\t\t\"ETA\": -2209161600000,\r\n\t\t\t\t\"arriveTimeUTC\": -2209161600000,\r\n\t\t\t\t\"maneuverType\": \"esriDMTStop\"\r\n\t\t\t},\r\n\t\t\t\"compressedGeometry\": \"+0+1+2+174gnf+5qbp7j+1vvdvh3+0+0|+5rg+d4s+0\"\r\n\t\t}]\r\n\t}]\r\n}\r\n"
        let routeSchipolLocal = Bundle.main.url(forResource: "routeSchiphol", withExtension: "json")
        do {
            let decoder = JSONDecoder()

            let stringData = routeString.data(using: .utf8)
            let schipholRoutesString = try! decoder.decode(Json4Swift_Base.self,
                                                           from: stringData!)
            print(schipholRoutesString)

            let data = try! String.init(contentsOf: routeSchipolLocal!)
            let schipholRoutes = try! decoder.decode(Json4Swift_Base.self,
                                                     from: data.data(using: .utf8)!)
            print(schipholRoutes)

        }
        catch {
            //Handle error
            print()
        }
        
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
