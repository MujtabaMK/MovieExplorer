//
//  YouTubePlayerView.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 09/07/25.
//

import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {
    let videoKey: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.configuration.allowsInlineMediaPlayback = true
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let embedHTML = """
        <html>
        <body style="margin:0px;padding:0px;">
        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoKey)?playsinline=1" frameborder="0" allowfullscreen></iframe>
        </body>
        </html>
        """
        uiView.loadHTMLString(embedHTML, baseURL: nil)
    }
}

