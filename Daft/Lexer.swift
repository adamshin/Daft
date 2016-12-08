//
//  Lexer.swift
//  Daft
//
//  Created by Adam Shin on 12/7/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum LexerError: Error {
    case unexpectedCharacter
}

class Lexer {
    
    private let input: LexerInput
    
    init(input: LexerInput) {
        self.input = input
    }
    
    func nextToken() throws -> Token? {
        skipWhitespace(in: input)
        
        guard let char = input.nextChar() else { return nil }
        
        if isIdentifierCharacter(char) { return readIdentifierOrKeyword(from: input) }
        if isIntLiteralCharacter(char) { return readIntLiteral(from: input) }
        if isOperatorCharacter(char) { return try readBinaryOperator(from: input) }
        
        input.consumeChar()
        switch char {
        case "=": return .assign
        case ",": return .comma
            
        case "(": return .leftParen
        case ")": return .rightParen
        case "{": return .leftBrace
        case "}": return .rightBrace
            
        case "\n": return .newline
        
        default: return nil
        }
    }
    
    private func skipWhitespace(in input: LexerInput) {
        while let char = input.nextChar(), isWhitespaceCharacter(char) {
            input.consumeChar()
        }
    }
    
    private func readIdentifierOrKeyword(from input: LexerInput) -> Token {
        var string = ""
        while let char = input.nextChar(), isIdentifierCharacter(char) {
            input.consumeChar()
            string.append(char)
        }
        
        switch string {
        case "let": return .letKeyword
        case "func": return .funcKeyword
        default: return .identifier(value: string)
        }
    }
    
    private func readIntLiteral(from input: LexerInput) -> Token {
        var string = ""
        while let char = input.nextChar(), isIntLiteralCharacter(char) {
            input.consumeChar()
            string.append(char)
        }
        return .intLiteral(value: string)
    }
    
    private func readBinaryOperator(from input: LexerInput) throws -> Token {
        guard let char = input.nextChar() else { throw LexerError.unexpectedCharacter }
        input.consumeChar()
        
        switch char {
        case "+": return .binaryOperator(type: .addition)
        case "-": return .binaryOperator(type: .subtraction)
            
        default: throw LexerError.unexpectedCharacter
        }
    }
    
}

private func isWhitespaceCharacter(_ char: Character) -> Bool {
    return String(char).rangeOfCharacter(from: .whitespaces) != nil
}

private func isIdentifierCharacter(_ char: Character) -> Bool {
    switch char {
    case "a"..."z", "A"..."Z", "_": return true
    default: return false
    }
}

private func isIntLiteralCharacter(_ char: Character) -> Bool {
    switch char {
    case "0"..."9": return true
    default: return false
    }
}

private func isOperatorCharacter(_ char: Character) -> Bool {
    switch char {
    case "+", "-": return true
    default: return false
    }
}
