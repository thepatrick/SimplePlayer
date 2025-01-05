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
    
    // let pub = NotificationCenter.default.publisher(for: AVPlayer.rateDidChangeNotification)
    // On the VideoPlayer():
    // .onReceive(pub) { (output) in
    //    print("rateDidChangeNotification \(player.items().count) \(player.currentTime())")
    // }
    
    func addAllVideosToPlayer() {
        player.removeAllItems()
        player.preventsDisplaySleepDuringVideoPlayback = true
        player.actionAtItemEnd = .advance
        
        for url in urls.shuffled() {
            let asset = AVURLAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
                
            player.insert(playerItem, after: nil)
        }
    }

    var body: some View {
        Group {
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
                .onAppear { player.play() }
                .onDisappear() { player.pause() }
                .onReceive(player.publisher(for: \.currentItem)) { (item) in
                    if player.items().count == 0 {
                        self.addAllVideosToPlayer()
                    }
                }
        }
        .onChange(of: urls, initial: true) { // fyi initial means on every appear
            self.addAllVideosToPlayer()
        }
    }
}
