//
//  TerminalUtils.swift
//  Helper
//
//  Created by Danil Lyskin on 03.12.2023.
//

import Foundation

internal class TerminalUtils {
    private static let sound = SoundEffect.systemSoundEffect
    
    static func playSound() {
        self.sound?.play()
    }
    
    static func replaceAsCurrentPath(_ path: String) -> String {
        path + " % "
    }
    
    static func getError(message error: Error) -> String {
        var errorMessage = Array(error.localizedDescription)
        
        let leftErrorMessageIndex = errorMessage.firstIndex(of: "“") ?? 0
        let rightErrorMessageIndex = errorMessage.lastIndex(of: "”") ?? 0
        
        errorMessage.removeLast(errorMessage.count - rightErrorMessageIndex)
        errorMessage.removeFirst(leftErrorMessageIndex + 1)
        
        return String(errorMessage)
    }
}
