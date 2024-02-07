//
//  TerminalWindowController.swift
//  Helper
//
//  Created by Danil Lyskin on 27.11.2023.
//

import AppKit

internal class TerminalWindowController: NSWindowController {
    internal convenience init() {
        self.init(window: TerminalWindow())
    }
}

extension TerminalWindowController: NSWindowDelegate {}
