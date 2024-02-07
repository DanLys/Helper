//
//  TerminalState.swift
//  Helper
//
//  Created by Danil Lyskin on 03.12.2023.
//

import Foundation

internal struct TerminalState {
    enum BuiltinsCommand: String {
        case cd
        case pwd
        case echo
    }
    var currentDir: String
}
