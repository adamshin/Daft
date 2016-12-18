//
//  Parser+CodeBlock.swift
//  Daft
//
//  Created by Adam Shin on 12/17/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Parser {
    
    func parseCodeBlock() throws -> ASTCodeBlock {
        var statements = [ASTStatement]()
        
        try consume(.leftBrace)
        while true {
            guard let token = input.nextToken() else { throw ParserError.endOfFile }
            
            if token == .rightBrace {
                break
            } else {
                try statements.append(parseStatement())
            }
        }
        try consume(.rightBrace)
        
        return ASTCodeBlock(statements: statements)
    }

}
