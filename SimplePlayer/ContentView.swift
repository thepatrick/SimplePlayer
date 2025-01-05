//
//  ContentView.swift
//  SimplePlayer
//
//  Created by Patrick Quinn-Graham on 5/1/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @State private var showFileImporter = false

    @State private var model = Conductor() // Create the state object.
    
    var body: some View {
        

        Group {
            if !model.booted || model.loading || model.bootError != nil {
                VStack {
                    if !model.booted {
                        Button("Boot") {
                            showFileImporter = true
                        }
                    } else if let error = model.bootError {
                        Text("Error: \(error)")
                    } else {
                        ProgressView()

                    }
                }.padding()
            } else {
                VideoPlayerView(urls: model.items)
            }
        }
        .onAppear() {
//            model.boot()
        }.fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.directory]
        ) { result in
             switch result {
             case .success(let directory):
                 // gain access to the directory
                 let gotAccess = directory.startAccessingSecurityScopedResource()
                 if !gotAccess { return }
                 // access the directory URL
                 // (read templates in the directory, make a bookmark, etc.)
                 model.boot(from: directory)
//                 onTemplatesDirectoryPicked(directory)
                 // release access
//                 directory.stopAccessingSecurityScopedResource()
             case .failure(let error):
                 // handle error
                 print(error)
             }
        }
        
    }
}

#Preview {
    ContentView()
}
