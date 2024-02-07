//
//  BashLine.swift
//  Helper
//
//  Created by Danil Lyskin on 22.11.2023.
//

import Foundation

internal protocol CommandExecuting {
    func run(commandName: String, arguments: [String], currentPath: String) throws -> String
}

internal enum BashError: Error {
    case commandNotFound(name: String)
}

internal class Bash: CommandExecuting {
    private (set) static var shared: Bash = {
        Bash()
    }()
    
    private init() {}
    
    internal func run(commandName: String, arguments: [String] = [], currentPath: String) throws -> String {
        return try run(resolve(commandName), with: arguments, path: currentPath)
    }

    private func resolve(_ command: String) throws -> String {
        guard var bashCommand = try? run("/bin/zsh" , with: ["-l", "-c", "which \(command)"]) else {
            throw BashError.commandNotFound(name: command)
        }
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return bashCommand
    }

    private func run(_ command: String, with arguments: [String] = [], path: String = "") throws -> String {
        let process = Process()
        process.currentDirectoryURL = URL(filePath: path)
        process.launchPath = command
        process.arguments = arguments
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        try process.run()
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        
        let arrayOutput = Array(output)
        var result = [Character]()
        var index = 0
        while index < arrayOutput.count {
            if index + 1 < arrayOutput.count
                && arrayOutput[index + 1] == "\u{8}" {
                index += 2
            } else {
                result.append(arrayOutput[index])
                index += 1
            }
        }
        
        return String(result)
    }
}
