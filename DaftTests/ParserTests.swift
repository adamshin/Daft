//
//  ParserTests.swift
//  Daft
//
//  Created by Adam Shin on 12/11/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

// MARK: - Test Cases

private let testCases: [(input: [Token], expected: AST)] = [
    (
        input: [
            .identifier("foo"),
            .binaryOperator(.addition),
            .intLiteral("42"),
            .semicolon,
        ],
        expected: AST(
            statements: [
                ASTExpressionStatement(
                    expression: ASTBinarySeriesExpression(
                        expressions: [
                            ASTPostfixExpression(
                                primaryExpression: ASTIdentifierExpression(name: "foo"),
                                postfixes: []
                            ),
                            ASTPostfixExpression(
                                primaryExpression: ASTIntLiteralExpression(literal: "42"),
                                postfixes: []
                            )
                        ],
                        operators: [
                            .addition
                        ]
                    )
                )
            ]
        )
    )
]

class ParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testParser() {
        testCases.forEach { testCase in
            let parser = Parser(input: ParserArrayInput(tokens: testCase.input))
            let ast = try! parser.parse()
            
            XCTAssertEqual(ast.description, testCase.expected.description)
        }
    }
    
}
