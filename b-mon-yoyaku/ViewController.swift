//
//  ViewController.swift
//  b-mon-yoyaku
//
//  Created by akinov on 2018/03/04.
//  Copyright © 2018年 akinov. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: Propaties
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var reserveBtn: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         webView.navigationDelegate = self
        
        // 表示するWEBサイトのURLを設定
        let urlRequest = URLRequest(url: URL(string: Const.url)!)
        // webViewで表示するWEBサイトの読み込みを開始
        webView.load(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // WKNavigationDelegate Methods
    // webView読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

    // MARK: Actions
    @IBAction func reserveClicked(_ sender: Any) {
        checkReserve()
    }
    
    // MARK: Private Actions
    private func checkReserve() {
        webView.evaluateJavaScript(
            JavaScript.reserve,
            completionHandler: { (html, error) -> Void in
                print(html)
                print(html as? Bool)
        })
    }
}

