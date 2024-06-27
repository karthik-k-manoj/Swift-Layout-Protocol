//
//  ContentView.swift
//  SwiftUILayoutProtocol
//
//  Created by Karthik K Manoj on 27/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                contents()
            }
        }
        .padding()
    }
    
    @ViewBuilder func contents() -> some View {
        Image(systemName: "globe.americas.fill")
        Text("Hello World")
        Image(systemName: "globe.europe.africa.fill")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
