//
//  LexerInput.swift
//  Daft
//
//  Created by Adam Shin on 12/7/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

protocol LexerInput {
    
    func nextChar() -> Character?
    func consumeChar()
    
}

class LexerStringInput: LexerInput {
    
    let string: String
    var location: String.Index
    
    init(string: String) {
        self.string = string
        location = string.startIndex
    }
    
    func nextChar() -> Character? {
        guard location < string.endIndex else { return nil }
        
        return string[location]
    }
    
    func consumeChar() {
        guard location < string.endIndex else { return }
        
        location = string.index(location, offsetBy: 1)
    }
    
}
