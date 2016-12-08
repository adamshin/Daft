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
