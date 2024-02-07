//
//  TerminalConstants.swift
//  Helper
//
//  Created by Danil Lyskin on 01.12.2023.
//

import Foundation
import AppKit

internal enum TerminalSize {
    static var height: CGFloat {
        (NSScreen.main?.frame.height ?? 0) / 2
    }
    
    static var width: CGFloat {
        (NSScreen.main?.frame.width ?? 0) / 2
    }
}

let rootDir = "file:///"
