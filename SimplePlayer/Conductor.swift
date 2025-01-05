//
//  Conductor.swift
//  SimplePlayer
//
//  Created by Patrick Quinn-Graham on 5/1/25.
//

import Foundation

// BootFailed error
enum Error: Swift.Error {
    case bootFailed
}

@Observable
class Conductor {
    
    var booted = false
    
    var loading = false
    
    var items: [URL] = []
    
    var bootError: Error?
    
    func boot(from url: URL ) {
        booted = true
        do {
            loading = true
            try findItems(at: url)
        } catch {
            bootError = Error.bootFailed
        }
        loading = false
    }
    
    func findItems(at url: URL) throws {
        // Find all mov or mp4 files within the directory url
   
        let files = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            .filter { url in
                return url.pathExtension.lowercased() == "mov" ||                 url.pathExtension.lowercased() == "m4v"
            }
        
        for file in files {
            print("Found \(file)")
        }
        
        items = files
    }
    
}
