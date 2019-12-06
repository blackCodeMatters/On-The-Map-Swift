//
//  WebViewController.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 12/3/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    
    //MARK: - Variables and Constants
    var mediaUrl: String = ""
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        
        self.tabBarController?.tabBar.isHidden = true
        guard let url = URL(string: mediaUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
