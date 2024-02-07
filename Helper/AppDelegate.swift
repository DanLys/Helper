//
//  AppDelegate.swift
//  Helper
//
//  Created by Danil Lyskin on 21.11.2023.
//

import Cocoa
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {

    let hotKeyHandler = HotkeyHandler()
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.setupStatusItemButton()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    private func setupStatusItemButton() {
        if let button = self.statusItem.button {
            button.image = .statusBarItem
        }
    }
}

