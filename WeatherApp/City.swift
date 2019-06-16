//
//  City.swift
//  WeatherApp
//
//  Created by 西谷恭紀 on 2019/06/15.
//  Copyright © 2019 西谷恭紀. All rights reserved.
//

import Foundation
import SwiftyJSON

//市区町村クラス
class City {
    let id: String      //地域ID
    let title: String   //市区町村名
    
    init(city: JSON) {
        id = city["id"].stringValue
        title = city["title"].stringValue
    }
}
