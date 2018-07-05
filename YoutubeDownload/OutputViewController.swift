//
//  OutputViewController.swift
//  YoutubeDownload
//
//  Created by Angelo Rodriguez on 13.06.18.
//  Copyright © 2018 Arya. All rights reserved.
//

import Cocoa

class OutputViewController: NSViewController {

    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var progessLabel: NSTextField!
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.nameLabel.stringValue = NSLocalizedString("title", tableName: nil, bundle: Bundle.main, value: "Title", comment: "Title")
        self.progessLabel.stringValue = NSLocalizedString("starting", tableName: nil, bundle: Bundle.main, value: "Starting", comment: "Starting")
        
        let arguments = self.appDelegate.command.split { $0 == " " }.map(String.init)
        print(arguments)
        
        let task = Process()
        task.launchPath = "/usr/local/bin/youtube-dl"
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe

        let handle = pipe.fileHandleForReading
        
        handle.readabilityHandler = { pipe in
            if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
                
                if (line.starts(with: "[youtube] ")) {
                    let id = line.replacingOccurrences(of: "[youtube] ", with: "").split(separator: ":")[0]
                    
                    let targuments = ["--get-title", "https://www.youtube.com/watch?v=\(id)"]
                    
                    let ttask = Process()
                    ttask.launchPath = "/usr/local/bin/youtube-dl"
                    ttask.arguments = targuments
                    
                    let tpipe = Pipe()
                    ttask.standardOutput = tpipe
                    
                    let thandle = tpipe.fileHandleForReading
                    
                    thandle.readabilityHandler = { tpipe in
                        if let tline = String(data: tpipe.availableData, encoding: String.Encoding.utf8) {
                            DispatchQueue.main.async {
                                if (tline != "") {
                                self.nameLabel.stringValue = tline;
                                NSLog("Setting Title \"\(tline)\"")
                                }
                                ttask.suspend()
                            }
                        } else {
                            print("Error decoding data: \(tpipe.availableData)")
                        }
                    }
                    
                    ttask.launch()
                }
                
                
                if (line.starts(with: "\r\u{1B}[K[download]   ") || line.starts(with: "\r\u{1B}[K[download]  ")) {
                    DispatchQueue.main.async {
                        self.progressBar.isIndeterminate = false
                    }
                    let percents = line.replacingOccurrences(of: "\r\u{1B}[K[download]  ", with: "").split(separator: "%")[0]
                    let percent = percents.replacingOccurrences(of: " ", with: "")
                    let size = line.replacingOccurrences(of: "of ", with: "+").split(separator: "+")[1].replacingOccurrences(of: " at", with: "+").split(separator: "+")[0]
                    let sizeunit = size.suffix(3)
                    let remainingTime = line.replacingOccurrences(of: "ETA ", with: "+").split(separator: "+")[1]
                    let sizedouble = Double(size.replacingOccurrences(of: sizeunit, with: ""))!
                    var dlsize = (Double(percent)! / 100) * sizedouble
                    dlsize = Double(round(1000*dlsize)/1000)
                    
                    DispatchQueue.main.async {
                        self.progressBar.doubleValue = Double(percent)!
                        let msg = "Downloading: \(dlsize)\(sizeunit) \(NSLocalizedString("ofvalue", tableName: nil, bundle: Bundle.main, value: "of", comment: "Val of Val")) \(size) - \(NSLocalizedString("remainingtime", tableName: nil, bundle: Bundle.main, value: "Remaining Time", comment: "Remaining Time")) \(remainingTime)"
                        self.progessLabel.stringValue = msg
                    }
                    
                }
                
                if (line.starts(with: "[ffmpeg]")) {
                    DispatchQueue.main.async {
                        self.progressBar.isIndeterminate = true
                        self.progessLabel.stringValue = NSLocalizedString("postprocessing", tableName: nil, bundle: Bundle.main, value: "Post Processing", comment: "Post Processing")
                    }
                }
                
                if (!task.isRunning) {
                    DispatchQueue.main.async {
                        self.progressBar.isIndeterminate = false
                        self.progressBar.doubleValue = 100
                        self.progessLabel.stringValue = NSLocalizedString("finished", tableName: nil, bundle: Bundle.main, value: "Finished", comment: "Finished")
                    }
                }
                
                print("N:\(line)")
            } else {
                print("Error decoding data: \(pipe.availableData)")
            }
        }
        
        task.launch()
    }
    
}
