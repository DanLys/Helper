//
//  HotkeyHandler.swift
//  Helper
//
//  Created by Danil Lyskin on 22.11.2023.
//

import Foundation
import HotKey

internal class HotkeyHandler {
    private let hotKeyTerminalOpen = HotKey(key: .t, modifiers: [.command, .shift])
    private let hotKeyTerminalClose = HotKey(key: .escape, modifiers: [.command, .shift])
    private var terminalOpenState = false
    private let windowController = TerminalWindowController()
    
    init() {
        self.hotKeyTerminalOpen.keyDownHandler = { [weak self] in
            guard let self = self else { return }
            
            if self.terminalOpenState {
                self.windowController.close()
                self.terminalOpenState = false
                return
            }
            
            self.windowController.window?.delegate = self.windowController
            self.windowController.window?.makeKey()
            self.windowController.showWindow(self)
            NSApp.activate(ignoringOtherApps: true)
            self.terminalOpenState = true
        }
        
        self.hotKeyTerminalClose.keyDownHandler = { [weak self] in
            guard let self = self else { return }
            
            self.windowController.close()
        }
    }
}
