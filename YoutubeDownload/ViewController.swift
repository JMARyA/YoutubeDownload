//
//  ViewController.swift
//  YoutubeDownload
//
//  Created by Angelo Rodriguez on 30.05.18.
//  Copyright © 2018 Arya. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSOpenSavePanelDelegate {
    
    @IBOutlet weak var audioFormatButton: NSPopUpButton!
    @IBOutlet weak var videoFormatButton: NSPopUpButton!
    @IBOutlet weak var qualityButton: NSPopUpButton!
    @IBOutlet weak var downloadPlaylistCheckBox: NSButton!
    @IBOutlet weak var downloadPathDisplay: NSPathControl!
    @IBOutlet weak var videoURLTextField: NSTextField!
    @IBOutlet weak var filenameFormatTextField: NSTextField!
    @IBOutlet weak var getDescriptionCheckBox: NSButton!
    @IBOutlet weak var getInfoCheckBox: NSButton!
    @IBOutlet weak var getThumbnailCheckBox: NSButton!
    @IBOutlet weak var getSubtitlesCheckBox: NSButton!
    @IBOutlet weak var extractAudioCheckBox: NSButton!
    @IBOutlet weak var recodeVideoCheckBox: NSButton!
    @IBOutlet weak var keepOriginalCheckBox: NSButton!
    @IBOutlet weak var embedSubtitlesCheckBox: NSButton!
    @IBOutlet weak var embedThumbnailCheckBox: NSButton!
    @IBOutlet weak var embedMetadataCheckBox: NSButton!
    @IBOutlet weak var skipVideoDownloadCheckBox: NSButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioFormatButton.removeAllItems()
        self.audioFormatButton.addItems(withTitles: ["Best Format", "AAC", "FLAC", "MP3", "M4A", "OPUS", "VORBIS", "WAV"])
        self.videoFormatButton.removeAllItems()
        self.videoFormatButton.addItems(withTitles: ["MP4", "FLV", "OGG", "WEBM", "MKV", "AVI"])
        
        self.qualityButton.removeAllItems()
        self.qualityButton.addItems(withTitles: ["Best", "2160p", "1440p", "1080p", "720p", "480p", "360p", "240p", "144p"])
        
        self.downloadPathDisplay.pathStyle = NSPathControl.Style.popUp
        self.downloadPathDisplay.url = URL(string: getDownloadsDirectory())
        
        
        }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    
    func generateCommand() -> String {
        //var cmd = "/usr/local/bin/youtube-dl"
        var cmd = " "
        if (self.downloadPlaylistCheckBox.state == NSControl.StateValue.on) {
            cmd += " --yes-playlist"
        } else {
            cmd += " --no-playlist"
        }
        
        cmd += " --ffmpeg-location /usr/local/bin/ffmpeg"
        
        switch self.qualityButton.selectedItem?.title {
        case "Best":
            break
        case "2160p":
            cmd += " -f bestvideo[height<=?2160]+bestaudio/best[height<=?2160]"
            break
        case "1440p":
            cmd += " -f bestvideo[height<=?1440]+bestaudio/best[height<=?1440]"
            break
        case "1080p":
            cmd += " -f bestvideo[height<=?1080]+bestaudio/best[height<=?1080]"
            break
        case "720p":
            cmd += " -f bestvideo[height<=?720]+bestaudio/best[height<=?720]"
            break
        case "480p":
            cmd += " -f bestvideo[height<=?480]+bestaudio/best[height<=?480]"
            break
        case "360p":
            cmd += " -f bestvideo[height<=?360]+bestaudio/best[height<=?360]"
            break
        case "240p":
            cmd += " -f bestvideo[height<=?240]+bestaudio/best[height<=?240]"
            break
        case "144p":
            cmd += " -f bestvideo[height<=?144]+bestaudio/best[height<=?144]"
            break
        default:
            break
        }
        
        let dir = self.downloadPathDisplay.url!.path.replacingOccurrences(of: " ", with: "\\ ")
        
        cmd += " -o \(dir)/\(self.filenameFormatTextField.stringValue)"
        
        if (self.getDescriptionCheckBox.state == NSControl.StateValue.on) {
            cmd += " --write-description"
        }
        if (self.getInfoCheckBox.state == NSControl.StateValue.on) {
            cmd += " --write-info-json"
        }
        if (self.getThumbnailCheckBox.state == NSControl.StateValue.on) {
            cmd += " --write-thumbnail"
        }
        if (self.getSubtitlesCheckBox.state == NSControl.StateValue.on) {
            cmd += " --write-sub"
        }
        if (self.skipVideoDownloadCheckBox.state == NSControl.StateValue.on) {
            cmd += " --skip-download"
        }
        
        if (self.extractAudioCheckBox.state == NSControl.StateValue.on) {
            var format = ""
            if (self.audioFormatButton.selectedItem?.title == "Best Format") {
                format = "best"
            } else {
                format = (self.audioFormatButton.selectedItem?.title.lowercased())!
            }
            cmd += " --extract-audio --audio-format \(format)"
        }
        
        if (self.recodeVideoCheckBox.state == NSControl.StateValue.on) {
            cmd += " --recode-video \(self.videoFormatButton.selectedItem!.title.lowercased())"
        }
        
        if (self.keepOriginalCheckBox.state == NSControl.StateValue.on) {
            cmd += " --keep-video"
        }
        
        if (self.embedSubtitlesCheckBox.state == NSControl.StateValue.on) {
            cmd += " --embed-subs"
        }
        if (self.embedThumbnailCheckBox.state == NSControl.StateValue.on) {
            cmd += " --embed-thumbnail"
        }
        if (self.embedMetadataCheckBox.state == NSControl.StateValue.on) {
            cmd += " --add-metadata"
        }
        
        cmd += " " + self.videoURLTextField.stringValue
        
        return cmd
    }
    
    
    @IBAction func processButton(_ sender: Any) {
        print(shell(input: generateCommand()))
    }
    
    func getDownloadsDirectory() -> String {
        let dir = NSHomeDirectory().split(separator: "/")
        var str = "file:///"
        str += dir[0] + "/"
        str += dir[1] + "/Downloads/"
        return str
    }
    
    
    
}
