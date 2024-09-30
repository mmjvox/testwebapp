//
//  WebViewModel.swift
//  testwebapp
//
//  Created by mmjvox on 9/29/24.
//

import SwiftUI
import WebKit

class WebViewModel: NSObject, ObservableObject, WKScriptMessageHandler {
    var webView: WKWebView?
    private var contentController: WKUserContentController!

    override init() {
        super.init()
        setupContentController()
    }

    private func setupContentController() {
        contentController = WKUserContentController()
        contentController.add(self, name: "nativeCallback") // Register the script message handler
    }

    func loadHTMLFile(named htmlFileName: String) {
        if let url = Bundle.main.url(forResource: htmlFileName, withExtension: "html", subdirectory: "PWA") {
            webView?.loadFileURL(url, allowingReadAccessTo: url)
        }
        else if let htmlPath = Bundle.main.path(forResource: htmlFileName, ofType: "html") {
            do {
                let htmlContent = try String(contentsOfFile: htmlPath, encoding: .utf8)
                webView?.loadHTMLString(htmlContent, baseURL: nil)
            } catch {
                print("Error loading HTML file: \(error)")
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // You can execute JavaScript here if needed after the page finishes loading
        print("WebView did finish loading")
    }
    
    func getContentController() -> WKUserContentController {
        return self.contentController;
    }

    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "nativeCallback", let messageBody = message.body as? [String: Any] {
            if let recipient = messageBody["recipient"] as? String, let message = messageBody["message"] as? String, let msgID = messageBody["messageID"] as? Int {
                LaunchSMS().sendSMS(recipient: recipient, messageBody: message) { result in
                    switch result {
                    case .cancelled:
                        self.msgToJs_Cancelled(messageID: msgID) { evaluated in
                            if(!evaluated){
                                self.showAlert(title: "Cancelled", message: "Message was cancelled by the user.")
                            }
                        }
                    case .sent:
                        self.msgToJs_Sent(messageID: msgID) { evaluated in
                            if(!evaluated){
                                self.showAlert(title: "Success", message: "Message sent successfully!")
                            }
                        }
                    case .failed:
                        self.msgToJs_Failed(messageID: msgID) { evaluated in
                            if(!evaluated){
                                self.showAlert(title: "Failed", message: "Message failed to send.")
                            }
                        }
                    @unknown default:
                        self.msgToJs_UnknownErr(messageID: msgID) { evaluated in
                            if(!evaluated){
                                self.showAlert(title: "Failed", message: "Message failed to send for unknown reason.")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        // Present the alert on the root view controller
        rootViewController.present(alert, animated: true, completion: nil)
    }
    
    
    
    func msgToJs_Cancelled(messageID: Int, _ completion: @escaping (Bool) -> Void){
        webView?.evaluateJavaScript("window.javaScriptCancelled(\(messageID))") { (result, error) in
            if let returnedMsgID = result as? Int{
                completion(error == nil && returnedMsgID > -1)
            } else {
                completion(false)
            }
        }
    }
    
    func msgToJs_Sent(messageID: Int, _ completion: @escaping (Bool) -> Void){
        webView?.evaluateJavaScript("window.javaScriptSent(\(messageID))") { (result, error) in
            if let returnedMsgID = result as? Int{
                completion(error == nil && returnedMsgID > -1)
            } else {
                completion(false)
            }
        }
    }
    
    func msgToJs_Failed(messageID: Int, _ completion: @escaping (Bool) -> Void){
        
        webView?.evaluateJavaScript("window.javaScriptFailed(\(messageID))") { (result, error) in
            if let error = error {
                print("Error sending message to JavaScript: \(error)")
                completion(false)
            } else {
                print("Message sent to JavaScript: \(String(describing: result))")
                if let returnedMsgID = result as? Int{
                    completion(error == nil && returnedMsgID > -1)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func msgToJs_UnknownErr(messageID: Int, _ completion: @escaping (Bool) -> Void){
        webView?.evaluateJavaScript("window.javaScriptUnknownErr(\(messageID))") { (result, error) in
            if let returnedMsgID = result as? Int{
                completion(error == nil && returnedMsgID > -1)
            } else {
                completion(false)
            }
        }
    }
}

