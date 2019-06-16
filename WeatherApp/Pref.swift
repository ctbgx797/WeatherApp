//
//  Pref.swift
//  WeatherApp
//
//  Created by 西谷恭紀 on 2019/06/15.
//  Copyright © 2019 西谷恭紀. All rights reserved.
//

import Foundation
import SwiftyJSON

//都道府県クラス
class Pref {
    let title: String   //都道府県名
    let cities: [City]  //都道府県内の市区町村データ

    
    init(pref: JSON) {
        title = pref["title"].stringValue
        cities = pref["city"].arrayValue.map({ item in
            return City(city: item)
        })
    }
}
