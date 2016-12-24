//
//  ParserInput.swift
//  Daft
//
//  Created by Adam Shin on 12/10/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

protocol ParserInput {
    func nextToken() -> Token?
    func consumeToken()
}

class ParserArrayInput: ParserInput {
    
    let tokens: [Token]
    var location: Int
    
    init(tokens: [Token]) {
        self.tokens = tokens
        location = 0
    }
    
    func nextToken() -> Token? {
        guard location < tokens.count else { return nil }
        return tokens[location]
    }
    
    func consumeToken() {
        guard location < tokens.count else { return }
        location += 1
    }
    
}

class ParserLexerInput: ParserInput {
    
    let lexer: Lexer
    var storedToken: Token?
    
    init(lexer: Lexer) {
        self.lexer = lexer
        storedToken = nil
    }
    
    func nextToken() -> Token? {
        if storedToken == nil {
            do {
                storedToken = try lexer.nextToken()
            }
            catch let error {
                NSLog("Error lexing input: \(error)")
            }
        }
        return storedToken
    }
    
    func consumeToken() {
        storedToken = nil
    }
    
}
