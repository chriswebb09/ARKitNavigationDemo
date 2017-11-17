/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct FieldAliases : Codable {
	let objectID : String?
	let name : String?
	let firstStopID : String?
	let lastStopID : String?
	let stopCount : String?
	let total_PedestrianTime : String?
	let shape_Length : String?

	enum CodingKeys: String, CodingKey {

		case objectID = "ObjectID"
		case name = "Name"
		case firstStopID = "FirstStopID"
		case lastStopID = "LastStopID"
		case stopCount = "StopCount"
		case total_PedestrianTime = "Total_PedestrianTime"
		case shape_Length = "Shape_Length"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		objectID = try values.decodeIfPresent(String.self, forKey: .objectID)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		firstStopID = try values.decodeIfPresent(String.self, forKey: .firstStopID)
		lastStopID = try values.decodeIfPresent(String.self, forKey: .lastStopID)
		stopCount = try values.decodeIfPresent(String.self, forKey: .stopCount)
		total_PedestrianTime = try values.decodeIfPresent(String.self, forKey: .total_PedestrianTime)
		shape_Length = try values.decodeIfPresent(String.self, forKey: .shape_Length)
	}

}
