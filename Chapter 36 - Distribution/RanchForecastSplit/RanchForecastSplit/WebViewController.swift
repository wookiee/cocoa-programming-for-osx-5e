//
//  RanchForecastSplit.swift
//  RanchForecastSplit
//
//  Created by Juan Pablo Claude on 2/20/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa
import WebKit


class WebViewController: NSViewController {
    
    var webView: WKWebView {
        return view as! WKWebView
    }
    
    
    override func loadView() {
        let webView = WKWebView()
        view = webView
    }
    
    
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
