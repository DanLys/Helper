//
//  main.swift
//  Helper
//
//  Created by Danil Lyskin on 27.11.2023.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
