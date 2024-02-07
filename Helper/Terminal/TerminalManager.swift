//
//  TerminalManager.swift
//  Helper
//
//  Created by Danil Lyskin on 03.12.2023.
//

import AppKit
import DequeModule

internal protocol TerminalManagerDelegate: AnyObject {
    func getCurrentDir() -> String
    
    @discardableResult
    func reduce(commandLine: String) -> String
    
    func autocomplite(_ line: String) -> String
    func getSavedCommand() -> String
}

internal class TerminalManager {
    private enum TerminalErrors: String {
        case builtinCommand = "shell built-in command"
    }
    
    private var state: TerminalState
    private var render: NSViewController?
    private let bash = Bash.shared
    private var commandQueue = Deque<String>()
    
    internal convenience init() {
        self.init(state: TerminalState(currentDir: rootDir))
    }
    
    internal init(state: TerminalState) {
        self.state = state
        self.commandQueue.append("")
    }
    
    internal func open() -> NSViewController {
        let terminalViewController = TerminalViewController()
        terminalViewController.delegate = self
        self.render = terminalViewController
        
        return terminalViewController
    }
}

extension TerminalManager: TerminalManagerDelegate {
    
    @discardableResult
    func reduce(commandLine: String) -> String {
        let commandClearLine = commandLine.removeFirstWhitespaces()
        
        var word = ""
        var linesWord = [String]()
        
        for el in commandClearLine {
            if el.isWhitespace {
                linesWord.append(word)
                word = ""
            } else {
                word += String(el)
            }
        }
        
        var result = TerminalUtils.replaceAsCurrentPath(self.state.currentDir)
        let commandName = linesWord.removeFirst()
        let arguments = Array(linesWord)
        
        do {
            result = try self.bash.run(commandName: commandName,
                                       arguments: arguments,
                                       currentPath: self.state.currentDir)
            
            self.commandQueue.prepend(commandName + "\(arguments.count != 0 ? " " : "")" + arguments.joined(separator: " "))
        } catch {
            var errorMessage = TerminalUtils.getError(message: error)
            if errorMessage.hasSuffix(TerminalErrors.builtinCommand.rawValue) {
                errorMessage.removeLast(TerminalErrors.builtinCommand.rawValue.count + 2)
                
                if let changeType = TerminalState.BuiltinsCommand(rawValue: errorMessage) {
                    switch changeType {
                    case .cd:
                        let newDir = arguments.first ?? rootDir
                        if newDir == ".." {
                            let currentURL = URL(filePath: self.state.currentDir)
                            let lastPath = currentURL.lastPathComponent
                            
                            self.state.currentDir.removeLast(lastPath.count + 1)
                        } else if newDir == "~" {
                            self.state.currentDir = rootDir
                        } else {
                            self.state.currentDir += "/\(newDir)"
                        }
                        result = ""
                    case .pwd:
                        result = self.state.currentDir + "\n"
                    case .echo:
                        break
                    }
                    
                    self.commandQueue.prepend(commandName + " " + arguments.joined(separator: " "))
                }
            } else {
                result = "\(error)\n"
            }
        }
        
        return result
    }
    
    func getCurrentDir() -> String {
        return self.state.currentDir
    }
    
    func autocomplite(_ line: String) -> String {
        let linePaths = (line.components(separatedBy: " ").last ?? "")
                        .components(separatedBy: "/")
                        .dropLast()
                        .joined(separator: "/")
        
        let autocompliteLine = (line.components(separatedBy: " ").last ?? "")
                                .components(separatedBy: "/").last ?? ""
        
        let stringPaths = (try? self.bash.run(commandName: "ls", currentPath: self.state.currentDir + linePaths)) ?? ""
        let paths = stringPaths.components(separatedBy: "\n")
        
        var numberOfСoincidence = 0
        var result = ""
        for path in paths {
            if path.hasPrefix(autocompliteLine) {
                numberOfСoincidence += 1
                result = path
            }
        }
        
        if numberOfСoincidence == 1 && line != result {
            result += "/"
            return String(result.dropFirst(autocompliteLine.count))
        } else {
            TerminalUtils.playSound()
            return ""
        }
    }
    
    func getSavedCommand() -> String {
        let command = self.commandQueue.popFirst()
        guard let command = command else { return "" }
        self.commandQueue.append(command)
        
        return command
    }
}
