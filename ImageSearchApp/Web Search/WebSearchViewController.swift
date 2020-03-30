//
//  SecondViewController.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

import UIKit
import WebKit

class WebSearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var webKitView: WKWebView!
    @IBOutlet weak var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webKitView.navigationDelegate = self
        searchTextField.delegate = self
        loadingView.isHidden = true
    }

    private func search() {
        view.endEditing(true)
        let text = searchTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let myURL = URL(string:"https://www.google.com/search?q=\(text)")
        let myRequest = URLRequest(url: myURL!)
        webKitView.load(myRequest)
    }
    
    @IBAction func searcButtonPressed(_ sender: Any) {
        search()
    }
}

extension WebSearchViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingView.isHidden = true
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.isHidden = true
    }
}

extension WebSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}

