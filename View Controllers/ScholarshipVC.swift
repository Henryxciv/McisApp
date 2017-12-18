//
//  ScholarshipVC.swift
//  McisApp
//
//  Created by Henry Akaeze on 11/20/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//


import UIKit
import WebKit

class ScholarshipVC: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func forwarDBtnPressed(_ sender: Any) {
        if webView.canGoForward{
            webView.goForward()
        }
    }
    @IBAction func refreshBtnPressed(_ sender: Any) {
        webView.reload()
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        if webView.canGoBack{
            webView.goBack()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "http://bluebird.mvsu.edu/internships.html")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
