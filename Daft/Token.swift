//
//  Token.swift
//  Daft
//
//  Created by Adam Shin on 12/7/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum Token {
    case identifier(String)
    case intLiteral(String)
    case stringLiteral(String)
    
    case binaryOperator(BinaryOperatorType)
    
    case funcKeyword
    case letKeyword
    
    case assign
    
    case leftParen
    case rightParen
    case leftBrace
    case rightBrace
    
    case comma
    case newline
}

extension Token: Equatable { }

func ==(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case (.identifier(let a), .identifier(let b)) where a == b: return true
    case (.intLiteral(let a), .intLiteral(let b)) where a == b: return true
    case (.stringLiteral(let a), .stringLiteral(let b)) where a == b: return true
        
    case (.binaryOperator(let a), .binaryOperator(let b)) where a == b: return true
        
    case (.funcKeyword, .funcKeyword): return true
    case (.letKeyword, .letKeyword): return true
        
    case (.assign, .assign): return true
        
    case (.leftParen, .leftParen): return true
    case (.rightParen, .rightParen): return true
    case (.leftBrace, .leftBrace): return true
    case (.rightBrace, .rightBrace): return true
        
    case (.comma, .comma): return true
    case (.newline, .newline): return true
        
    default: return false
    }
}