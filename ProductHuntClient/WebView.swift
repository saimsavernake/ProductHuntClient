//
//  WebView.swift
//  ProductHuntClient
//
//  Created by Алёшкина on 14.11.16.
//  Copyright © 2016 Slim. All rights reserved.
//

import UIKit

class WebView: UIViewController {
    
    
    @IBOutlet var webViewOutlet: UIWebView!
    
    
    var link = String()
    
    
    override func viewDidLoad() {
        loadUrl()
    }
    
    func loadUrl() {
        let requestUrl = NSURL(string: self.link)
        let request = NSURLRequest(url: requestUrl as! URL)
        webViewOutlet.loadRequest(request as URLRequest)
    }
    
}
