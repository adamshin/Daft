//
//  Token.swift
//  Daft
//
//  Created by Adam Shin on 12/7/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum Token {
    case identifier(value: String)
    case intLiteral(value: String)
    
    case binaryOperator(type: BinaryOperatorType)
    
    case funcKeyword
    case letKeyword
    
    case assign
    case comma
    
    case leftParen
    case rightParen
    case leftBrace
    case rightBrace
    
    case newline
}

enum BinaryOperatorType {
    case addition
    case subtraction
}
