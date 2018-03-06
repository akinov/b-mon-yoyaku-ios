//
//  ViewController.swift
//  b-mon-yoyaku
//
//  Created by akinov on 2018/03/04.
//  Copyright © 2018年 akinov. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
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
        updateBtn()
        
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
        guard let url = webView.url else { return }
        let urlString = url.absoluteString

        if urlString.contains("move") {
            status = .move
            checkMove()
        }
        else if urlString.contains("punchbag") {
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
                    self.scheduledReload()
                }
        })
    }
    
    private func reserveComplete() {
        webView.evaluateJavaScript(
            JavaScript.reserveComplete,
            completionHandler: { (html, error) -> Void in
                if (html as? Bool)! {
                    self.status = .pause
                }
                else {
                    // 成功しない場合再実行？
                    self.reserveComplete()
                }
        })
    }
    
    private func checkMove() {
        guard let savedBagRanges = loadBagRanges() else {
            status = .pause
            showNoBagRangeAlert()
            return
        }

        webView.evaluateJavaScript(
            String(format: JavaScript.move, bagRangeToStr(savedBagRanges)),
            completionHandler: { (html, error) -> Void in
                if (html as? Bool)! {
                    self.status = .pause
                } else {
                    self.scheduledReload()
                }
        })
    }
    
    private func updateBtn() {
        guard let url = webView.url else { return }
        let urlString = url.absoluteString

        if urlString.contains("punchbag") || urlString.contains("move") {
            if status == .pause {
                reserveBtn.isEnabled = true
                pauseBtn.isEnabled = false
            }
            else {
                reserveBtn.isEnabled = false
                pauseBtn.isEnabled = true
            }
        }
        else {
            reserveBtn.isEnabled = false
            pauseBtn.isEnabled = false
        }
    }
    
    private func scheduledReload() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reloadWebView), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadWebView() {
        if status == .pause { return }
        webView.reload()
    }
    
    private func loadBagRanges() -> [BagRange]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: BagRange.ArchiveURL.path) as? [BagRange]
    }
    
    private func showNoBagRangeAlert() {
        let alertController = UIAlertController(title: "移動先バッグが未登録です", message: "右下のボタンを押して優先したい移動先を登録してください", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func bagRangeToStr(_ bagRanges: [BagRange]) -> String {
        return bagRanges.map {
            return Array(Int($0.start)...Int($0.end))
            }.joined().map {
                return String(format: "'%02d'", $0)
            }.joined(separator: ",")
        
    }
}

