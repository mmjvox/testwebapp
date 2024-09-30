//
//  ContentView.swift
//  testwebapp
//
//  Created by mmjvox on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var webViewModel = WebViewModel()
    
    var body: some View {
        WebView(viewModel: webViewModel, htmlFileName: "index")
            .edgesIgnoringSafeArea(.all) // Optional, to make WebView cover the full screen
    }
}


#Preview {
    ContentView()
}
