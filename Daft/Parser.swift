//
//  Parser.swift
//  Daft
//
//  Created by Adam Shin on 12/10/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case unexpectedToken
    case endOfFile
    
    case internalError
}

class Parser {
    
    let input: ParserInput
    
    init(input: ParserInput) {
        self.input = input
    }
    
    func parse() throws -> ASTProgram {
        var statements = [ASTStatement]()
        
        while input.nextToken() != nil {
            try statements.append(parseStatement())
        }
        return ASTProgram(statements: statements)
    }
    
    func consume(_ token: Token) throws {
        guard let nextToken = input.nextToken() else { throw ParserError.endOfFile }
        guard token == nextToken else { throw ParserError.unexpectedToken }
        
        input.consumeToken()
    }
    
}
