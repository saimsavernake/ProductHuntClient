//
//  Post.swift
//  ProductHuntClient
//
//  Created by Алёшкина on 13.11.16.
//  Copyright © 2016 Slim. All rights reserved.
//

import UIKit

class Post: UIViewController {
    
    
    
    
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var postText: UILabel!
    @IBOutlet var getItButton: UIButton!
    
    var postImageVar = String()
    var postTitleVar = String()
    var postTextVar = String()
    var postLinkVar = String()
    
    override func viewDidLoad() {

        let data = try? Data(contentsOf: URL(string: postImageVar)!)
        postImage.image = UIImage(data: data!)
        postTitle.text = postTitleVar
        postText.text = postTextVar
        
        self.navigationItem.title = postTitleVar
        
    }
    
    
    
    @IBAction func getItButton(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToWebView" {
            let controller = segue.destination as! WebView
            controller.link = self.postLinkVar
        }
    }
    
}
