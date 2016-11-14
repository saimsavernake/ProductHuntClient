//
//  RearViewController.swift
//  ProductHuntClient
//
//  Created by Алёшкина on 14.11.16.
//  Copyright © 2016 Slim. All rights reserved.
//

import UIKit
import SwiftyJSON

class RearViewController: UITableViewController {

    
    var categories = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catUrl = "https://api.producthunt.com/v1/categories"
        let token = "?access_token=591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
        if let url = URL(string: (catUrl+token)) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                parseCategories(json: json)
            }
        }
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category = self.categories[indexPath.row]
        cell.textLabel?.text = category["category"]

        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToMain" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let DestViewController = segue.destination as! UINavigationController
                let controller = DestViewController.topViewController as! Main
                controller.currentCategory = categories[indexPath.row]["category"]!
            }
        }
        
    }
    
    
    func parseCategories(json: JSON) {
        for result in json["categories"].arrayValue {
            let categories = result["slug"].stringValue
            let object = ["category": categories]
            self.categories.append(object)
        }
    }
    
}
