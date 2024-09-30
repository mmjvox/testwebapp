//
//  WebViewController.swift
//  testwebapp
//
//  Created by mmjvox on 9/29/24.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    var webViewModel = WebViewModel() // Your WebViewModel instance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure the WKWebView
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = webViewModel.getContentController() // Attach the content controller from WebViewModel
        
        webViewModel.webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webViewModel.webView?.uiDelegate = self // Set the WKUIDelegate to self

        // Add the webView to the view controller's view
        if let webView = webViewModel.webView {
            self.view.addSubview(webView)
        }
        
        // Load the HTML file
        webViewModel.loadHTMLFile(named: "example") // Change "example" to your HTML file name
    }

    // Handle any JavaScript alerts here if needed
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "JavaScript Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // Show native alert function
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
