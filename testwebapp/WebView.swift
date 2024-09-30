//
//  WebView.swift
//  testwebapp
//
//  Created by mmjvox on 9/29/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    let htmlFileName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: makeConfiguration())
        viewModel.webView = webView // Set the global webView
        return webView
    }

    private func makeConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = viewModel.getContentController() // Assign the content controller
        return configuration
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        viewModel.loadHTMLFile(named: htmlFileName)
    }
}
