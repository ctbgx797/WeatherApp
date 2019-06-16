//
//  TableViewController.swift
//  WeatherApp
//
//  Created by 西谷恭紀 on 2019/06/15.
//  Copyright © 2019 西谷恭紀. All rights reserved.
//

import UIKit
import Alamofire    //通信処理を簡単に書くことができる
import SwiftyJSON   //使いやすいようになる
import SDWebImage

class TableViewController: UITableViewController {

    // 地域一覧
    var prefectures: [Pref] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Alamofireを利用して通信を行います。
        Alamofire.request("https://script.google.com/macros/s/AKfycbyFEiNBHOJcs5pGhh1JuKsK17moh3C6TDHD31Gk01NCPcZcwdcA/exec").responseJSON { (response: DataResponse<Any>) in
            
            //Errorの場合､通信ができない場合
            if response.result.isFailure == true {
                self.simpleAlert(title: "通信エラー", message: "通信に失敗しました")
                return
            }
            guard let val = response.result.value as? [String:Any] else {
                self.simpleAlert(title: "通信エラー", message: "通信結果がJSONではありませんでした")
                return
            }
            
            //ここがswiftyJSON
            // responseJSONを使うと辞書形式でも扱えますが、今回はより簡単に扱うためにSwiftyJSONを利用します。
            let json = JSON(val)
            
            // 取得データを扱いやすいデータに変更
            //[][][][]←コイツらが階層
            let prefJSON = json["rss"]["channel"]["source"]["pref"].arrayValue
            
            self.prefectures = prefJSON.map({ (item: JSON) in
                return Pref(pref: item)
            })
            self.tableView.reloadData()
            // 確認用
            print(prefJSON)
        }
    }

    func simpleAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // セクションの数を返す
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return prefectures.count
    }
    
    // セクション毎の列の数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cities = prefectures[section].cities
        return cities.count
    }
    
    // セクションのタイトルを返す(都道府県名)
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return prefectures[section].title
    }
    
    // セルにタイトルとIDを設定する(市区町村とID)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefCell", for: indexPath) as! TableViewCell
        
        cell.titleLabel.text = prefectures[indexPath.section].cities[indexPath.row].title
        cell.idLabel.text = prefectures[indexPath.section].cities[indexPath.row].id
        
        return cell
    }
    
    // 画面遷移時に地域IDを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先にDetailViewControllerがあるかを確認
        if let detailVC = segue.destination as? DetailViewController {
            // 選択したセルが持つIDを取得し、遷移先に渡す
            //TableViewCellにsenderを入れる且つ､押したセルのインデックスパスが存在するときは､detailVCのcityIDを入れている
            if let cell = sender as? TableViewCell, let indexPath = tableView.indexPath(for: cell) {
                //都道府県の何番目か､市町村の情報､何番目かを特定してIDを返している
                detailVC.cityID = prefectures[indexPath.section].cities[indexPath.row].id
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
