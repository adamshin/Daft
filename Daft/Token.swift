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

enum BinaryOperatorType {
    case addition
    case subtraction
    
    case lessThan
    case greaterThan
    
    case equality
}
