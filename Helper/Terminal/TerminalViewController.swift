//
//  TerminalViewController.swift
//  Helper
//
//  Created by Danil Lyskin on 01.12.2023.
//

import AppKit

internal class TerminalViewController: NSViewController {
    
    private let scrollView = NSTextView.scrollableTextView().forAutolayout()
    private var commandLine = NSTextView().forAutolayout()
    weak var delegate: TerminalManagerDelegate?
    private var loaded = false
    private var lockCheckingChange = false
    private var isRemoving = false
    
    private var currentLine = ""
    
    override func loadView() {
        self.view = NSView(frame: NSMakeRect(0.0, 0.0, TerminalSize.width, TerminalSize.height))
        self.view.layer = CALayer()
        
        self.view.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.6).cgColor
        
        self.view.layer?.cornerRadius = 10
        self.view.clipsToBounds = true
        
        self.commandLine = self.scrollView.documentView as! NSTextView
        self.view.addSubview(self.scrollView)
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.setupText()
    }
    
    private func setupText() {
        self.commandLine.backgroundColor = .clear
        self.commandLine.textColor = .white
     
        self.commandLine.isEditable = true
        self.commandLine.isSelectable = true
        self.commandLine.importsGraphics = true
        
        self.commandLine.delegate = self
        
        self.commandLine.insertionPointColor = .white
        
        self.writeDir()
        self.loaded = true
        
        self.commandLine.isVerticallyResizable = true

        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        scrollView.drawsBackground = false
        self.commandLine.drawsBackground = false
    }
    
    private func writeDir() {
        self.addLastLine(TerminalUtils.replaceAsCurrentPath(self.delegate?.getCurrentDir() ?? ""))
    }
    
    private func print(writer: () -> ()) {
        self.lockCheckingChange = true
        
        writer()
        
        self.lockCheckingChange = false
    }
    
    private func addLastLine(_ line: String) {
        self.print {
            self.commandLine.insertText(line, replacementRange: NSRange(location: self.commandLine.textStorage?.length ?? 0, length: 0))
        }
    }
    
    private func write(_ word: String) {
        self.print {
            self.commandLine.insertText(word, replacementRange: NSRange(location: self.commandLine.textStorage?.length ?? 0, length: 0))
            
            self.currentLine = self.currentLine + word
        }
    }
    
    private func rewrite(_ word: String) {
        self.print {
            self.commandLine.string.removeLast(self.currentLine.count)
            self.commandLine.insertText(word, replacementRange: NSRange(location: self.commandLine.string.count, length: 0))
            
            self.currentLine = word
        }
    }
}

extension TerminalViewController: NSTextViewDelegate {
    func textView(_ textView: NSTextView, willChangeSelectionFromCharacterRange oldSelectedCharRange: NSRange, toCharacterRange newSelectedCharRange: NSRange) -> NSRange {
        
        if newSelectedCharRange.location < (self.commandLine.string.count - self.currentLine.count) {
            self.rewrite(self.delegate?.getSavedCommand() ?? "")
            return NSRange(location: self.commandLine.string.count, length: 0)
        }
    
        return newSelectedCharRange
    }
    
    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        
        if replacementString == "\t" {
            self.write(self.delegate?.autocomplite(self.currentLine) ?? "")
            return false
        }
        
        if replacementString == "" {
            self.isRemoving = true
        } else {
            self.isRemoving = false
        }
        
        return (self.currentLine.count == 0 && replacementString != "") || self.currentLine.count > 0 || !self.loaded
    }
    
    func textDidChange(_ notification: Notification) {
        guard !self.lockCheckingChange else { return }
        
        let lastLineSymbols = self.commandLine.string.suffix(1)
        
        if lastLineSymbols == "\n" {
            self.addLastLine(self.delegate?.reduce(commandLine: self.currentLine + "\n") ?? "")
            self.currentLine = ""
            self.writeDir()
        } else if self.loaded && !self.isRemoving {
            self.currentLine += String(self.commandLine.string.last ?? Character(""))
        } else if self.isRemoving {
            self.currentLine.removeLast()
        }
    }
}
