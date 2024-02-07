//
//  String+Additional.swift
//  Helper
//
//  Created by Danil Lyskin on 03.12.2023.
//

import Foundation

extension String {
    func removeFirstWhitespaces() -> Self {
        var whitespaceCounter = 0
        var slf = self
        
        for el in self {
            if el.isWhitespace {
                whitespaceCounter += 1
            } else {
                break
            }
        }
        
        slf.removeFirst(whitespaceCounter)
        return slf
    }
}
