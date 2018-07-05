//
//  SafariExtensionViewController.swift
//  Download With YoutubeDownload
//
//  Created by Angelo Rodriguez on 04.07.18.
//  Copyright © 2018 Arya. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
