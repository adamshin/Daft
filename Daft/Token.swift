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
    
    case ifKeyword
    case varKeyword
    case funcKeyword
    
    case leftParen
    case rightParen
    case leftBrace
    case rightBrace
    
    case comma
    case semicolon
}

extension Token: Equatable { }

func ==(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case (.identifier(let a), .identifier(let b)) where a == b: return true
    case (.intLiteral(let a), .intLiteral(let b)) where a == b: return true
    case (.stringLiteral(let a), .stringLiteral(let b)) where a == b: return true
        
    case (.binaryOperator(let a), .binaryOperator(let b)) where a == b: return true
        
    case (.ifKeyword, .ifKeyword): return true
    case (.varKeyword, .varKeyword): return true
    case (.funcKeyword, .funcKeyword): return true
        
    case (.leftParen, .leftParen): return true
    case (.rightParen, .rightParen): return true
    case (.leftBrace, .leftBrace): return true
    case (.rightBrace, .rightBrace): return true
        
    case (.comma, .comma): return true
    case (.semicolon, .semicolon): return true
        
    default: return false
    }
}
