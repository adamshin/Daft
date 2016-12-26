//
//  Parser+Expression.swift
//  Daft
//
//  Created by Adam Shin on 12/10/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Parser {
    
    // MARK: - Expressions
    
    func parseExpression() throws -> ASTExpression {
        return try parseBinarySeriesExpression()
    }
    
    func parseBinarySeriesExpression() throws -> ASTBinarySeriesExpression {
        var expressions = [ASTPostfixExpression]()
        var operators = [ASTBinaryOperator]()
        
        try expressions.append(parsePostfixExpression())
        
        while let token = input.nextToken(), case let .binaryOperator(op) = token {
            input.consumeToken()
            
            operators.append(ASTBinaryOperator(type: op))
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
                try postfixes.append(parseFunctionCallArgumentList())
            } else {
                break
            }
        }
        return ASTPostfixExpression(primaryExpression: expression, postfixes: postfixes)
    }
    
    func parseFunctionCallArgumentList() throws -> ASTFunctionCallArgumentList {
        try consume(.leftParen)
        
        if input.nextToken() == .rightParen {
            input.consumeToken()
            return ASTFunctionCallArgumentList(arguments: [])
        }
        
        var arguments = [ASTExpression]()
        try arguments.append(parseExpression())
        
        while input.nextToken() != .rightParen {
            try consume(.comma)
            try arguments.append(parseExpression())
        }
        try consume(.rightParen)
        
        return ASTFunctionCallArgumentList(arguments: arguments)
    }
    
    // MARK: - Primary Expressions
    
    func parsePrimaryExpression() throws -> ASTPrimaryExpression {
        guard let token = input.nextToken() else { throw ParserError.endOfFile }
        
        switch token {
        case .leftParen:
            return try parseParenthesizedExpression()
            
        case .funcKeyword:
            return try parseFunctionExpression()
            
        case .identifier(_):
            return try parseIdentifier()
            
        case let .intLiteral(literal):
            input.consumeToken()
            return ASTIntLiteralExpression(literal: literal)
            
        case let .stringLiteral(literal):
            input.consumeToken()
            return ASTStringLiteralExpression(literal: literal)
            
        case let .boolLiteral(value):
            input.consumeToken()
            return ASTBoolLiteralExpression(value: value)
            
        default:
            throw ParserError.unexpectedToken
        }
    }
    
    func parseParenthesizedExpression() throws -> ASTParenthesizedExpression {
        try consume(.leftParen)
        let expression = try parseExpression()
        try consume(.rightParen)
        
        return ASTParenthesizedExpression(expression: expression)
    }
    
    func parseFunctionExpression() throws -> ASTFunctionExpression {
        try consume(.funcKeyword)
        
        let argumentList = try parseArgumentList()
        let codeBlock = try parseCodeBlock()
        
        return ASTFunctionExpression(argumentList: argumentList, codeBlock: codeBlock)
    }
    
    func parseArgumentList() throws -> ASTArgumentList {
        try consume(.leftParen)
        
        if input.nextToken() == .rightParen {
            input.consumeToken()
            return ASTArgumentList(arguments: [])
        }
        
        var arguments = [ASTIdentifierExpression]()
        try arguments.append(parseIdentifier())
        
        while input.nextToken() != .rightParen {
            try consume(.comma)
            try arguments.append(parseIdentifier())
        }
        try consume(.rightParen)
        
        return ASTArgumentList(arguments: arguments)
    }
    
    func parseIdentifier() throws -> ASTIdentifierExpression {
        guard let identifierToken = input.nextToken() else { throw ParserError.endOfFile }
        guard case let .identifier(name) = identifierToken else { throw ParserError.unexpectedToken }
        
        input.consumeToken()
        return ASTIdentifierExpression(name: name)
    }
    
}
