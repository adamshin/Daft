//
//  ParserTestHelpers.swift
//  Daft
//
//  Created by Adam Shin on 12/17/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

// MARK: - Test Cases

struct ParserTestCase {
    let input: String
    let expected: Any
}

struct ParserErrorCase {
    let input: String
    let error: ParserError
}

func testParser(testCases: [ParserTestCase], errorCases: [ParserErrorCase], test: (Parser) throws -> Any) {
    testCases.forEach {
        let tokens = try! Lexer(input: LexerStringInput(string: $0.input)).allTokens()
        let parser = Parser(input: ParserArrayInput(tokens: tokens))
        
        do {
            let result = try test(parser)
            
            let expected = String(describing: $0.expected)
            let actual = String(describing: result)
            
            XCTAssertEqual(actual, expected)
        }
        catch let error {
            XCTFail("Parser threw error on valid input: \(error)")
        }
    }
    
    errorCases.forEach {
        let tokens = try! Lexer(input: LexerStringInput(string: $0.input)).allTokens()
        let parser = Parser(input: ParserArrayInput(tokens: tokens))
        
        do {
            let _ = try test(parser)
            XCTFail("Parser failed to throw error.")
        }
        catch let error as ParserError {
            XCTAssertEqual(error, $0.error, "Parser threw incorrect error.")
        }
        catch {
            XCTFail("Parser threw unrecognized error.")
        }
    }
}

// MARK: - Structure

func codeBlock(_ statements: [ASTStatement]) -> ASTCodeBlock {
    return ASTCodeBlock(statements: statements)
}

func condition(_ expression: ASTExpression) -> ASTConditionClause {
    return ASTConditionClause(expression: expression)
}

// MARK: - Statements

func expression(_ expression: ASTExpression) -> ASTExpressionStatement {
    return ASTExpressionStatement(expression: expression)
}

func variableDeclaration(_ name: String, _ expression: ASTExpression?) -> ASTVariableDeclarationStatement {
    return ASTVariableDeclarationStatement(name: name, expression: expression)
}

func ifStatement(_ condition: ASTConditionClause, _ codeBlock: ASTCodeBlock) -> ASTIfStatement {
    return ASTIfStatement(condition: condition, codeBlock: codeBlock, elseClause: nil)
}

func ifStatement(_ condition: ASTConditionClause, _ codeBlock: ASTCodeBlock, _ elseClause: ASTElseClause) -> ASTIfStatement {
    return ASTIfStatement(condition: condition, codeBlock: codeBlock, elseClause: elseClause)
}

func elseIf(_ ifStatement: ASTIfStatement) -> ASTElseIfClause {
    return ASTElseIfClause(ifStatement: ifStatement)
}

func finalElse(_ codeBlock: ASTCodeBlock) -> ASTFinalElseClause {
    return ASTFinalElseClause(codeBlock: codeBlock)
}

func whileStatement(_ condition: ASTConditionClause, _ codeBlock: ASTCodeBlock) -> ASTWhileStatement {
    return ASTWhileStatement(condition: condition, codeBlock: codeBlock)
}

func returnStatement() -> ASTReturnStatement {
    return ASTReturnStatement(expression: nil)
}

func returnStatement(_ expression: ASTExpression) -> ASTReturnStatement {
    return ASTReturnStatement(expression: expression)
}

// MARK: - Expressions

func binarySeries(_ expression: ASTPostfixExpression) -> ASTBinarySeriesExpression {
    return ASTBinarySeriesExpression(expressions: [expression], operators: [])
}

func binarySeries(_ expressions: [ASTPostfixExpression], _ operators: [ASTBinaryOperator]) -> ASTBinarySeriesExpression {
    return ASTBinarySeriesExpression(expressions: expressions, operators: operators)
}

func binaryOperator(_ type: BinaryOperator) -> ASTBinaryOperator {
    return ASTBinaryOperator(type: type)
}

func postfix(_ primaryExpression: ASTPrimaryExpression) -> ASTPostfixExpression {
    return ASTPostfixExpression(primaryExpression: primaryExpression, postfixes: [])
}

func postfix(_ primaryExpression: ASTPrimaryExpression, _ postfixes: [ASTPostfix]) -> ASTPostfixExpression {
    return ASTPostfixExpression(primaryExpression: primaryExpression, postfixes: postfixes)
}

func functionCallArgumentList(_ arguments: [ASTExpression]) -> ASTFunctionCallArgumentList {
    return ASTFunctionCallArgumentList(arguments: arguments)
}

// MARK: - Primary expressions

func parenthesized(_ expression: ASTExpression) -> ASTParenthesizedExpression {
    return ASTParenthesizedExpression(expression: expression)
}

func function(_ argumentList: ASTArgumentList, _ codeBlock: ASTCodeBlock) -> ASTFunctionExpression {
    return ASTFunctionExpression(argumentList: argumentList, codeBlock: codeBlock)
}

func argumentList(_ arguments: [ASTIdentifierExpression]) -> ASTArgumentList {
    return ASTArgumentList(arguments: arguments)
}

func intLiteral(_ literal: String) -> ASTIntLiteralExpression {
    return ASTIntLiteralExpression(literal: literal)
}

func stringLiteral(_ literal: String) -> ASTStringLiteralExpression {
    return ASTStringLiteralExpression(literal: literal)
}

func boolLiteral(_ value: Bool) -> ASTBoolLiteralExpression {
    return ASTBoolLiteralExpression(value: value)
}

func voidLiteral() -> ASTVoidLiteralExpression {
    return ASTVoidLiteralExpression()
}

func identifier(_ name: String) -> ASTIdentifierExpression {
    return ASTIdentifierExpression(name: name)
}
