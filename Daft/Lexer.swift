//
//  Lexer.swift
//  Daft
//
//  Created by Adam Shin on 12/7/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum LexerError: Error {
    case endOfFile
    case unexpectedCharacter
    
    case internalError
}

class Lexer {
    
    private let input: LexerInput
    
    init(input: LexerInput) {
        self.input = input
    }
    
    func allTokens() throws -> [Token] {
        var tokens = [Token]()
        while let token = try nextToken() {
            tokens.append(token)
        }
        return tokens
    }
    
    func nextToken() throws -> Token? {
        skipWhitespace()
        
        guard let char = input.nextChar() else { return nil }
        
        if isIdentifierCharacter(char) { return readIdentifierOrKeyword() }
        if isIntLiteralCharacter(char) { return readIntLiteral() }
        if isStringDelimiter(char) { return try readStringLiteral() }
        
        if isOperatorCharacter(char) { return try readBinaryOperator() }
        
        input.consumeChar()
        switch char {
        case "(": return .leftParen
        case ")": return .rightParen
        case "{": return .leftBrace
        case "}": return .rightBrace
            
        case ",": return .comma
        case ";": return .semicolon
        
        default: throw LexerError.unexpectedCharacter
        }
    }
    
    private func skipWhitespace() {
        while let char = input.nextChar(), isWhitespaceCharacter(char) {
            input.consumeChar()
        }
    }
    
    private func readIdentifierOrKeyword() -> Token {
        var string = ""
        while let char = input.nextChar(), isIdentifierCharacter(char) {
            input.consumeChar()
            string.append(char)
        }
        
        switch string {
        case "if": return .ifKeyword
        case "else": return .elseKeyword
        case "while": return .whileKeyword
        
        case "func": return .funcKeyword
        case "var": return .varKeyword
        
        default: return .identifier(string)
        }
    }
    
    private func readIntLiteral() -> Token {
        var string = ""
        while let char = input.nextChar(), isIntLiteralCharacter(char) {
            input.consumeChar()
            string.append(char)
        }
        return .intLiteral(string)
    }
    
    private func readStringLiteral() throws -> Token {
        guard let char = input.nextChar(), isStringDelimiter(char) else {
            throw LexerError.internalError
        }
        
        input.consumeChar()
        
        var string = ""
        while let char = input.nextChar() {
            input.consumeChar()
            
            if isStringDelimiter(char) {
                return .stringLiteral(string)
            }
            string.append(char)
        }
        
        throw LexerError.endOfFile
    }
    
    private func readBinaryOperator() throws -> Token {
        guard let char = input.nextChar() else {
            throw LexerError.internalError
        }
        input.consumeChar()
        
        switch char {
        case "=":
            if input.nextChar() == "=" {
                input.consumeChar()
                return .binaryOperator(.equality)
            } else {
                return .binaryOperator(.assignment)
            }
            
        case "+": return .binaryOperator(.addition)
        case "-": return .binaryOperator(.subtraction)
        case "<": return .binaryOperator(.lessThan)
        case ">": return .binaryOperator(.greaterThan)
            
        default: throw LexerError.internalError
        }
    }
    
}

private func isWhitespaceCharacter(_ char: Character) -> Bool {
    return String(char).rangeOfCharacter(from: .whitespacesAndNewlines) != nil
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

private func isStringDelimiter(_ char: Character) -> Bool {
    return char == "\""
}

private func isOperatorCharacter(_ char: Character) -> Bool {
    switch char {
    case "+", "-", "<", ">", "=": return true
    default: return false
    }
}
