//
//  VideoPlayerView.swift
//  SimplePlayer
//
//  Created by Patrick Quinn-Graham on 5/1/25.
//

import Foundation
import SwiftUI
import AVKit


struct VideoPlayerView: View {
    @State var player = AVQueuePlayer()
    let urls: [URL]
    
    let pub = NotificationCenter.default.publisher(for: AVPlayer.rateDidChangeNotification)
    
    
    func addAllVideosToPlayer() {
        player.removeAllItems()
        
        player.preventsDisplaySleepDuringVideoPlayback = true
                    
        player.actionAtItemEnd = .advance
        
        for url in urls.shuffled() {
            if !url.startAccessingSecurityScopedResource() {
                print("url.startAccessingSecurityScopedResource() returned false for \(url)")
            }
            let asset = AVURLAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
                
            player.insert(playerItem, after: nil)
        }

//        player.replaceCurrentItem(with: playerItem)
//        player.play()
    }

    var body: some View {
        Group {
//            if let queuePlayer {
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        player.play()
                    }
                    .onDisappear() {
                        player.pause()
                    }.onReceive(pub) { (output) in
                        print("rateDidChangeNotification \(player.items().count) \(player.currentTime())")
                    }.onReceive(player.publisher(for: \.currentItem)) { (item) in
                        print("woah \(player.items().count)")
                        if player.items().count == 0 {
                            print("Re-add all videos")
                            self.addAllVideosToPlayer()
                        }
                    }
//            }
//            else {
//                Text("Invalid") // usually onChange will only occur the first time if there is something can can appear so this is just a placeholder but you can try without this.
//            }
        }
        .onChange(of: urls, initial: true) { // fyi initial means on every appear
            self.addAllVideosToPlayer()
        }
    }
}
