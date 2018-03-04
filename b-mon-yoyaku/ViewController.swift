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
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var reserveBtn: UIBarButtonItem!
    @IBOutlet weak var pauseBtn: UIBarButtonItem!
    var status: Status = .pause
    
    //MARK: Enum Propaties
    enum Status: String {
        case pause = "pause"
        case reserve = "reserve"
        case reserveConfirm = "reserveConfirm"
        case move = "move"
        case completed = "completed"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn.isEnabled = false
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        // 表示するWEBサイトのURLを設定
        let urlRequest = URLRequest(url: URL(string: Const.url)!)
        // webViewで表示するWEBサイトの読み込みを開始
        webView.load(urlRequest)
        
        updateBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // WKNavigationDelegate Methods
    // webView読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backBtn.isEnabled = webView.canGoBack
        
        switch status {
        case .pause:
            break
        case .reserve:
            checkReserve()
        case .reserveConfirm:
            reserveComplete()
        case .move:
            checkMove()
        default:
            break
        }
    }

    // MARK: Actions
    @IBAction func reserveClicked(_ sender: Any) {
        let url = webView.url!.absoluteString

        if url.contains("move") {
            status = .move
            checkMove()
        }
        else if url.contains("reserve") {
            status = .reserve
            checkReserve()
        }
        
        updateBtn()
    }
    
    @IBAction func pauseClicked(_ sender: Any) {
        status = .pause
        updateBtn()

    }
    
    @IBAction func backClicked(_ sender: Any) {
        webView.goBack()
        backBtn.isEnabled = webView.canGoBack
    }
    
    // MARK: Private Actions
    private func checkReserve() {
        webView.evaluateJavaScript(
            JavaScript.reserve,
            completionHandler: { (html, error) -> Void in
                if (html as? Bool)! {
                    self.status = .reserveConfirm
                } else {
                    self.webView.reload()
                }
        })
    }
    
    private func reserveComplete() {
        webView.evaluateJavaScript(
            JavaScript.reserveComplete,
            completionHandler: { (html, error) -> Void in
                if (html as? Bool)! {
                    self.status = .completed
                }
                else {
                    // 成功しない場合再実行？
                    self.reserveComplete()
                }
        })
    }
    
    private func checkMove() {
        webView.evaluateJavaScript(
            JavaScript.move,
            completionHandler: { (html, error) -> Void in
                if (html as? Bool)! {
                    self.status = .completed
                } else {
//                    sleep(3)
                    self.webView.reload()
                }
        })
    }
    
    private func updateBtn() {
        if status == .pause {
            reserveBtn.isEnabled = true
            pauseBtn.isEnabled = false
        }
        else {
            reserveBtn.isEnabled = false
            pauseBtn.isEnabled = true
        }
    }
}

