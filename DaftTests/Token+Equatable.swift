//
//  Token+Equatable.swift
//  Daft
//
//  Created by Adam Shin on 12/7/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation
@testable import Daft

extension Token: Equatable { }

func ==(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case (.identifier(let a), .identifier(let b)) where a == b: return true
    case (.intLiteral(let a), .intLiteral(let b)) where a == b: return true
    case (.binaryOperator(let a), .binaryOperator(let b)) where a == b: return true
        
    case (.funcKeyword, .funcKeyword): return true
    case (.letKeyword, .letKeyword): return true
        
    case (.assign, .assign): return true
    case (.comma, .comma): return true
        
    case (.leftParen, .leftParen): return true
    case (.rightParen, .rightParen): return true
    case (.leftBrace, .leftBrace): return true
    case (.rightBrace, .rightBrace): return true
        
    case (.newline, .newline): return true
        
    default: return false
    }
}
