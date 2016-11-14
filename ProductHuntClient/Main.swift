//
//  ViewController.swift
//  ProductHuntClient
//
//  Created by Алёшкина on 12.11.16.
//  Copyright © 2016 Slim. All rights reserved.
//

import UIKit
import SwiftyJSON

class Main: UITableViewController {

    
    var posts = [[String: String]]()
    var currentCategory = "tech"
    
    @IBOutlet var menuBarButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBarButton.target = self.revealViewController()
        menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let urlString = "https://api.producthunt.com/v1/categories/\(self.currentCategory)/posts"
        let token = "?access_token=591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
        if let url = URL(string: (urlString+token)) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                parse(json: json)
            }
        }
        refreshFunc()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        let post = posts[indexPath.row]
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                let data = try? Data(contentsOf: URL(string: post["img"]!)!)
                cell.mainImageView.image = UIImage(data: data!)
            }
        }
        
        cell.mainTitle.text = post["name"]
        cell.mainVotes.text = "Votes - \(post["votes"]!)"
        cell.mainDescription.text = post["description"]
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToThePost", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToThePost" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! Post
                controller.postTitleVar = posts[indexPath.row]["name"]!
                controller.postTextVar = posts[indexPath.row]["description"]!
                controller.postImageVar = posts[indexPath.row]["screenshot"]!
                controller.postLinkVar = posts[indexPath.row]["link"]!
            }
        }
    }
    
    
//MARK: - Parsing
    func parse(json: JSON) {
        for result in json["posts"].arrayValue {
            let postName = result["name"].stringValue
            let votes = result["votes_count"].stringValue
            let img = result["thumbnail"]["image_url"].stringValue
            let screenshot = result["screenshot_url"]["850px"].stringValue
            let description = result["tagline"].stringValue
            let link = result["discussion_url"].stringValue
            let object = ["name": postName, "votes": votes, "img": img, "screenshot": screenshot, "description": description, "link": link]
            posts.append(object)
        }
        
        tableView.reloadData()
    }
    
    
//MARK: - Refreshing
    func refreshFunc () {
        
        let refresh = UIRefreshControl()
        self.tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(Main.didRefresh), for: .valueChanged)
        
    }
    func didRefresh () {
        posts.removeAll()
        
        let urlString = "https://api.producthunt.com/v1/categories/\(self.currentCategory)/posts"
        let token = "?access_token=591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
        if let url = URL(string: (urlString+token)) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                parse(json: json)
            }
        }
        
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
}

