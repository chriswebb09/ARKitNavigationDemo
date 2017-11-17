/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Attributes : Codable {
	let length : Int?
	let time : Int?
	let text : String?
	let eTA : Int?
	let arriveTimeUTC : Int?
	let maneuverType : String?

	enum CodingKeys: String, CodingKey {

		case length = "length"
		case time = "time"
		case text = "text"
		case eTA = "ETA"
		case arriveTimeUTC = "arriveTimeUTC"
		case maneuverType = "maneuverType"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		length = try values.decodeIfPresent(Int.self, forKey: .length)
		time = try values.decodeIfPresent(Int.self, forKey: .time)
		text = try values.decodeIfPresent(String.self, forKey: .text)
        eTA = try values.decodeIfPresent(Int.self, forKey: .eTA)
		arriveTimeUTC = try values.decodeIfPresent(Int.self, forKey: .arriveTimeUTC)
		maneuverType = try values.decodeIfPresent(String.self, forKey: .maneuverType)
	}

}
