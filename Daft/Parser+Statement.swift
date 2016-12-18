//
//  Parser+Statement.swift
//  Daft
//
//  Created by Adam Shin on 12/17/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Parser {
    
    func parseStatementList() throws -> AST {
        var statements = [ASTStatement]()
        
        while input.nextToken() != nil {
            try statements.append(parseStatement())
        }
        return AST(statements: statements)
    }
    
    func parseStatement() throws -> ASTStatement {
        guard let token = input.nextToken() else { throw ParserError.endOfFile }
        
        let statement: ASTStatement
        
        switch token {
        case .varKeyword:
            statement = try parseVariableDeclarationStatement()
        default:
            statement = try parseExpressionStatement()
        }
        
        try consume(.semicolon)
        return statement
    }
    
    func parseExpressionStatement() throws -> ASTExpressionStatement {
        return try ASTExpressionStatement(expression: parseExpression())
    }
    
    func parseVariableDeclarationStatement() throws -> ASTVariableDeclarationStatement {
        try consume(.varKeyword)
        
        guard let identifierToken = input.nextToken() else { throw ParserError.endOfFile }
        guard case let .identifier(name) = identifierToken else { throw ParserError.unexpectedToken }
        
        input.consumeToken()
        
        var expression: ASTExpression?
        if let token = input.nextToken(), token == .assign {
            input.consumeToken()
            expression = try parseExpression()
        }
        
        return ASTVariableDeclarationStatement(name: name, expression: expression)
    }
    
}
