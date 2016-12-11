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
    
    private let input: ParserInput
    
    init(input: ParserInput) {
        self.input = input
    }
    
    func parse() throws -> AST {
        return try parseStatementList()
    }
    
    // MARK: - Statements
    
    func parseStatementList() throws -> AST {
        var statements = [ASTStatement]()
        
        while input.nextToken() != nil {
            try statements.append(parseStatement())
        }
        return AST(statements: statements)
    }
    
    func parseStatement() throws -> ASTStatement {
        return try parseExpressionStatement()
    }
    
    func parseExpressionStatement() throws -> ASTExpressionStatement {
        return try ASTExpressionStatement(expression: parseExpression())
    }
    
    // MARK: - Expressions
    
    func parseExpression() throws -> ASTExpression {
        return try parseBinarySeriesExpression()
    }
    
    func parseBinarySeriesExpression() throws -> ASTBinarySeriesExpression {
        var expressions = [ASTPostfixExpression]()
        var operators = [BinaryOperatorType]()
        
        try expressions.append(parsePostfixExpression())
        
        while let token = input.nextToken(), case let .binaryOperator(op) = token {
            input.consumeToken()
            
            operators.append(op)
            try expressions.append(parsePostfixExpression())
        }
        
        return ASTBinarySeriesExpression(expressions: expressions, operators: operators)
    }
    
    // MARK: - Postfix Expressions
    
    func parsePostfixExpression() throws -> ASTPostfixExpression {
        let expression = try parsePrimaryExpression()
        var postfixes = [ASTPostfix]()
        
        while input.nextToken() != nil {
            if input.nextToken() == .leftParen {
                try postfixes.append(parseFunctionArgumentList())
            } else {
                break
            }
        }
        return ASTPostfixExpression(primaryExpression: expression, postfixes: postfixes)
    }
    
    func parseFunctionArgumentList() throws -> ASTFunctionArgumentList {
        var arguments = [ASTExpression]()
        
        try consume(.leftParen)
        while input.nextToken() != .rightParen {
            try arguments.append(parseExpression())
            try consume(.comma)
        }
        try consume(.rightParen)
        
        return ASTFunctionArgumentList(arguments: [])
    }
    
    func parsePrimaryExpression() throws -> ASTPrimaryExpression {
        guard let token = input.nextToken() else {
            throw ParserError.endOfFile
        }
        
        switch token {
        case .leftParen:
            return try parseParenthesizedExpression()
            
        case let .intLiteral(literal):
            return ASTIntLiteralExpression(literal: literal)
            
        case let .stringLiteral(literal):
            return ASTStringLiteralExpression(literal: literal)
            
        case let .identifier(name):
            return ASTIdentifierExpression(name: name)
            
        default:
            throw ParserError.unexpectedToken
        }
    }
    
    // MARK: - Primary Expressions
    
    func parseParenthesizedExpression() throws -> ASTParenthesizedExpression {
        try consume(.leftParen)
        let expression = try parseExpression()
        try consume(.rightParen)
        
        return ASTParenthesizedExpression(expression: expression)
    }
    
    // MARK: - Helpers
    
    func consume(_ token: Token) throws {
        guard let nextToken = input.nextToken() else { throw ParserError.endOfFile }
        guard token == nextToken else { throw ParserError.unexpectedToken }
        
        input.consumeToken()
    }
    
}
