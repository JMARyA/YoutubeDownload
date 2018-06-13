//
//  OutputViewController.swift
//  YoutubeDownload
//
//  Created by Angelo Rodriguez on 13.06.18.
//  Copyright © 2018 Arya. All rights reserved.
//

import Cocoa

class OutputViewController: NSViewController {
    
    @IBOutlet weak var output: NSScrollView!
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.documentView!.insertText("Output")
    }
    
    override func viewDidAppear() {
        self.output.documentView!.insertText(shell(input: self.appDelegate.command))
    }
    
}
