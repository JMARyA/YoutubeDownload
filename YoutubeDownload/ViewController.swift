//
//  ViewController.swift
//  YoutubeDownload
//
//  Created by Angelo Rodriguez on 30.05.18.
//  Copyright © 2018 Arya. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var audioFormatButton: NSPopUpButton!
    @IBOutlet weak var videoFormatButton: NSPopUpButton!
    @IBOutlet weak var qualityButton: NSPopUpButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioFormatButton.removeAllItems()
        self.audioFormatButton.addItems(withTitles: ["Best Format", "AAC", "FLAC", "MP3", "M4A", "OPUS", "VORBIS", "WAV"])
        self.videoFormatButton.removeAllItems()
        self.videoFormatButton.addItems(withTitles: ["MP4", "FLV", "OGG", "WEBM", "MKV", "AVI"])
        
        self.qualityButton.removeAllItems()
        self.qualityButton.addItems(withTitles: ["Best", "2160p", "1440p", "1080p", "720p", "420p"])
        
        
        }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

