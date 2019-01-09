//
//  JWebViewController.swift
//  iosh5demo
//
//  Created by jackyshan on 2019/1/4.
//  Copyright © 2019年 Jacky Labs. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class JWebViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
    var wkwebview: WKWebView!
    var wkconfiguration: WKWebViewConfiguration!
    
    var jsFuncArr: [JsFuncModel] = [JsFuncModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initUI()
        initListner()
        initData()
    }
    
    func clearJs() {
        jsFuncArr.forEach { (obj) in
            wkwebview.configuration.userContentController.removeScriptMessageHandler(forName: obj.name)
        }
    }
    
    func initUI() {
        let configuration = WKWebViewConfiguration()
        configuration.preferences = WKPreferences()
        configuration.preferences.javaScriptEnabled = true
        configuration.userContentController = WKUserContentController()
        wkconfiguration = configuration
        
        let webview = WKWebView.init(frame: self.view.bounds, configuration: configuration)
        self.view.addSubview(webview)
        webview.navigationDelegate = self
        wkwebview = webview
    }
    
    func initListner() {
        
    }
    
    func initData() {
        
    }
    
    func loadH5(_ name: String) {
        wkwebview.load(URLRequest.init(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "html", inDirectory: "h5")!)))
    }
    
    func addJsFunc(_ name: String, _ callback:@escaping ((Any)->Void)) {
        wkconfiguration.userContentController.add(self, name: name)
        
        jsFuncArr.append(JsFuncModel.init(name: name, callback: callback))
    }
    
    func addJsObj(_ key: String, _ value: String) {
        wkwebview.evaluateJavaScript("vm.\(key) = \(value)", completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationItem.title = webView.title
    }
    
    //MARK 处理JS交互
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print(message.name)
        print(message.body)
        
        for jsFunc in jsFuncArr {
            if jsFunc.name == message.name {
                jsFunc.callback(message.body)
                break
            }
        }
    }

    deinit {
        print("webview销毁了")
    }
    
    struct JsFuncModel {
        var name: String
        var callback: ((Any)->Void)
    }
}
