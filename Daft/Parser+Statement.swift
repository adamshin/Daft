//
//  Parser+Statement.swift
//  Daft
//
//  Created by Adam Shin on 12/17/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Parser {
    
    func parseStatement() throws -> ASTStatement {
        guard let token = input.nextToken() else { throw ParserError.endOfFile }
        
        switch token {
        case .ifKeyword:
            return try parseIfStatement()
            
        case .whileKeyword:
            return try parseWhileStatement()
            
        case .varKeyword:
            let statement = try parseVariableDeclarationStatement()
            try consume(.semicolon)
            return statement
            
        case .returnKeyword:
            let statement = try parseReturnStatement()
            try consume(.semicolon)
            return statement
            
        default:
            let statement = try parseExpressionStatement()
            try consume(.semicolon)
            return statement
        }
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
        if let token = input.nextToken(), token == .binaryOperator(.assignment) {
            input.consumeToken()
            expression = try parseExpression()
        }
        
        return ASTVariableDeclarationStatement(name: name, expression: expression)
    }
    
    func parseIfStatement() throws -> ASTIfStatement {
        try consume(.ifKeyword)
        
        let condition = try parseConditionClause()
        let codeBlock = try parseCodeBlock()
        
        var elseClause: ASTElseClause?
        if let token = input.nextToken(), token == .elseKeyword {
            elseClause = try parseElseClause()
        }
        
        return ASTIfStatement(condition: condition, codeBlock: codeBlock, elseClause: elseClause)
    }
    
    func parseElseClause() throws -> ASTElseClause {
        try consume(.elseKeyword)
        
        guard let token = input.nextToken() else { throw ParserError.endOfFile }
        
        if token == .ifKeyword {
            let ifStatement = try parseIfStatement()
            return ASTElseIfClause(ifStatement: ifStatement)
        }
        else {
            let codeBlock = try parseCodeBlock()
            return ASTFinalElseClause(codeBlock: codeBlock)
        }
    }
    
    func parseWhileStatement() throws -> ASTWhileStatement {
        try consume(.whileKeyword)
        
        let condition = try parseConditionClause()
        let codeBlock = try parseCodeBlock()
        
        return ASTWhileStatement(condition: condition, codeBlock: codeBlock)
    }
    
    func parseReturnStatement() throws -> ASTReturnStatement {
        try consume(.returnKeyword)
        
        if input.nextToken() == .semicolon {
            return ASTReturnStatement(expression: nil)
        } else {
            let expression = try parseExpression()
            return ASTReturnStatement(expression: expression)
        }
    }
    
}
