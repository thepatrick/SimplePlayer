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
                        Text("No Folder Selected").font(.headline).padding()
                        Text("Use the Open Folder button in the toolbar to begin")
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
            model.retrieveSelectedDirectoryOrClear()
        }.fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.directory]
        ) { result in
             switch result {
             case .success(let directory):
                 model.selectNewFolder(directory)
             case .failure(let error):
                 // handle error
                 print(error)
             }
        }
        .toolbar {
            if let directory = model.selectedDirectory {
                Text(directory.lastPathComponent).fontWeight(.bold)
            }
            if model.booted {
                Text("\(model.items.count) videos")
            }
            Button("Open Folder") {
                showFileImporter = true
            }
            .disabled(model.loading)
            Button("Clear") {
                model.clear()
            }
            .disabled(model.loading || model.selectedDirectory == nil)
            
        }
        .frame(minWidth: 400, minHeight: 400)
        .windowToolbarFullScreenVisibility(.onHover)
    }
}

#Preview {
    ContentView()
}
