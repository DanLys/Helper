//
//  TerminalWindow.swift
//  Helper
//
//  Created by Danil Lyskin on 30.11.2023.
//

import AppKit

internal class TerminalWindow: NSWindow {
    private let terminalManager: TerminalManager
    
    internal init() {
        self.terminalManager = TerminalManager()
        
        var windowRect: NSRect = .zero
        
        if let mainFrame = NSScreen.main?.frame {
            let safeAreaTop = NSStatusBar.system.isVertical ? 0 : NSStatusBar.system.thickness
            windowRect = NSRect(origin: CGPoint(x: 50, y: mainFrame.maxY - safeAreaTop - TerminalSize.height),
                                size: .zero)
        }
        
        super.init(contentRect: windowRect, styleMask: .borderless, backing: .buffered, defer: false)
        
        self.backgroundColor = .clear
        self.contentViewController = self.terminalManager.open()
    }
    
    override var canBecomeKey: Bool { true }
}
