//
//  shell.swift
//  YoutubeDownload
//
//  Created by Angelo Rodriguez on 30.05.18.
//  Copyright © 2018 Arya. All rights reserved.
//

import Foundation


func shell(input: String) -> String {
    let arguments = input.split { $0 == " " }.map(String.init)
    print(arguments)
    
    let task = Process()
    task.launchPath = "/usr/local/bin/youtube-dl"
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    
    return output
}
