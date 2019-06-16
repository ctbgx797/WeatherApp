//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by 西谷恭紀 on 2019/06/15.
//  Copyright © 2019 西谷恭紀. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class DetailViewController: UIViewController {
    // 一覧画面から渡される地域ID
    var cityID = ""
    //Title
    @IBOutlet weak var titleLabel: UILabel!
    //今日の天気パーツ
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var todayImage: UIImageView!
    @IBOutlet weak var todayWeatherLabel: UILabel!
    @IBOutlet weak var todayTemperatureLabel: UILabel!
    //明日の天気パーツ
    @IBOutlet weak var tomorrowLabel: UILabel!
    @IBOutlet weak var tomorrowImage: UIImageView!
    @IBOutlet weak var tomorrowWeatherLabel: UILabel!
    @IBOutlet weak var tomorrowTemperatureLabel: UILabel!
    //明後日の天気パーツ
    @IBOutlet weak var afterTomorrowLabel: UILabel!
    @IBOutlet weak var afterTomorrowImage: UIImageView!
    @IBOutlet weak var afterTomorrowWeatherLabel: UILabel!
    @IBOutlet weak var afterTomorrowTemperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 念のためcityIDの中身があるかチェックします。
        //文字列(cityID)が空かどうかを判定する､空の時はsimpleAlert発動してguard文の中でreturnする
        guard !cityID.isEmpty else {
            self.simpleAlert(title: "エラー", message: "天気を取得する地域が指定されていません")
            return
        }
        
        // Alamofireを利用して通信を行います。
        Alamofire.request("http://weather.livedoor.com/forecast/webservice/json/v1?city=\(cityID)").responseJSON { (response: DataResponse<Any>) in
            //もし失敗したらエラーを吐きreturn
            if response.result.isFailure == true {
                self.simpleAlert(title: "通信エラー", message: "通信に失敗しました")
                return
            }
            //[String: Any]型でなければエラーを吐く
            guard let val = response.result.value as? [String: Any] else {
                self.simpleAlert(title: "通信エラー", message: "通信結果がJSONではありませんでした")
                return
            }
            // SwiftyJSONでJSONを利用
            let json = JSON(val)
            // タイトル部分
            self.titleLabel.text = json["title"].string
            
            // 天気の情報
            if let forecasts = json["forecasts"].array {
                print(forecasts)
                // 今日の天気
                let todayWeather = forecasts[0]
                //
                self.todayLabel.text = todayWeather["dateLabel"].stringValue
                if let imgUrl = todayWeather["image"]["url"].string {
                    self.todayImage.sd_setImage(with: URL(string: imgUrl))
                }
                self.todayWeatherLabel.text = todayWeather["telop"].stringValue
                
                self.todayTemperatureLabel.text = self.generateTemperatureText(todayWeather["temperature"])
                
                
                // 明日の天気
                let tomorrowWeather = forecasts[1]
                
                self.tomorrowLabel.text = tomorrowWeather["dateLabel"].stringValue
                if let imgUrl = tomorrowWeather["image"]["url"].string {
                    self.tomorrowImage.sd_setImage(with: URL(string: imgUrl))
                }
                self.tomorrowWeatherLabel.text = tomorrowWeather["telop"].stringValue
                
                self.tomorrowTemperatureLabel.text = self.generateTemperatureText(tomorrowWeather["temperature"])
                
                
                // 明後日の天気
                // 気象情報の更新が入るまで明後日の天気情報が存在しない場合があるので要素数をチェックします
                if forecasts.count >= 3 {
                let afterTomorrowWeather = forecasts[2]
                    
                self.afterTomorrowLabel.text = afterTomorrowWeather["dateLabel"].stringValue
                if let imgUrl = afterTomorrowWeather["image"]["url"].string {
                self.afterTomorrowImage.sd_setImage(with: URL(string: imgUrl))
                }
                self.afterTomorrowWeatherLabel.text = afterTomorrowWeather["telop"].stringValue
                self.afterTomorrowTemperatureLabel.text = self.generateTemperatureText(afterTomorrowWeather["temperature"])
                }
            }
            
        }
        
    }
    // 気温のラベル用テキストを生成します。
    func generateTemperatureText(_ temperature: JSON) -> String {
        
        var resultText = ""
        
        if let min = temperature["min"]["celsius"].string {
            resultText += min + "℃"
        } else {
            resultText += "-"
        }
        
        resultText += " / "
        
        if let max = temperature["max"]["celsius"].string {
            resultText += max + "℃"
        } else {
            resultText += "-"
        }
        
        return resultText
    }
    
    // 閉じるボタンのみのアラートを表示します。
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}
