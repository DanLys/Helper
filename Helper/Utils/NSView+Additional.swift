//
//  NSView+Additional.swift
//  Helper
//
//  Created by Danil Lyskin on 28.11.2023.
//

import AppKit

extension NSView {
    
    @discardableResult
    internal func forAutolayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
