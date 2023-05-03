//
//  ContentView.swift
//  VisionKit-Example
//
//  Created by Cédric Bahirwe on 03/05/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var content = ""
    var body: some View {
        ZStack {
            if content.isEmpty {
                ScannerView { scannedContent in
                    guard let scannedContent else { return }
                    self.content = scannedContent.joined()
                }
                .ignoresSafeArea()
            } else {
                ZStack {
                    Color.clear
                        .background(.regularMaterial)
                        .overlay {
                            VStack {
                                HStack {
                                    Button("< Back") {
                                        content = ""
                                    }.bold()
                                    Spacer()
                                }
                                .padding()

                                ScrollView {
                                    VStack(alignment: .leading) {
                                        Text(content)
                                            .font(.title2)
                                    }
                                    .padding()
                                }
                            }
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
