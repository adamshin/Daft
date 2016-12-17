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
    ),
    (
        input: [
            .varKeyword,
            .identifier("foo"),
            .assign,
            .identifier("bar"),
            .leftParen,
            .intLiteral("5"),
            .rightParen,
            .semicolon,
        ],
        expected: AST(
            statements: [
                ASTVariableDeclarationStatement(
                    name: "foo",
                    expression: ASTBinarySeriesExpression(
                        expressions: [
                            ASTPostfixExpression(
                                primaryExpression: ASTIdentifierExpression(name: "bar"),
                                postfixes: [
                                    ASTFunctionArgumentList(
                                        arguments: [
                                            ASTBinarySeriesExpression(
                                                expressions: [
                                                    ASTPostfixExpression(
                                                        primaryExpression: ASTIntLiteralExpression(literal: "5"),
                                                        postfixes: []
                                                    )
                                                ],
                                                operators: []
                                            )
                                        ]
                                    )
                                ]
                            )
                        ],
                        operators: []
                    )
                )
            ]
        )
    ),
    (
        input: [
            .intLiteral("1"),
            .binaryOperator(.addition),
            .leftParen,
            .intLiteral("2"),
            .binaryOperator(.addition),
            .intLiteral("3"),
            .rightParen,
            .binaryOperator(.subtraction),
            .intLiteral("4"),
            .semicolon,
        ],
        expected: AST(
            statements: [
                ASTExpressionStatement(
                    expression: ASTBinarySeriesExpression(
                        expressions: [
                            ASTPostfixExpression(
                                primaryExpression: ASTIntLiteralExpression(literal: "1"),
                                postfixes: []
                            ),
                            ASTPostfixExpression(
                                primaryExpression: ASTParenthesizedExpression(
                                    expression: ASTBinarySeriesExpression(
                                        expressions: [
                                            ASTPostfixExpression(
                                                primaryExpression: ASTIntLiteralExpression(literal: "2"),
                                                postfixes: []
                                            ),
                                            ASTPostfixExpression(
                                                primaryExpression: ASTIntLiteralExpression(literal: "3"),
                                                postfixes: []
                                            )
                                        ],
                                        operators: [
                                            .addition,
                                        ]
                                    )
                                ),
                                postfixes: []
                            ),
                            ASTPostfixExpression(
                                primaryExpression: ASTIntLiteralExpression(literal: "4"),
                                postfixes: []
                            )
                        ],
                        operators: [
                            .addition,
                            .subtraction,
                        ]
                    )
                )
            ]
        )
    ),
]

class ParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testParser() {
        testCases.forEach { testCase in
            let parser = Parser(input: ParserArrayInput(tokens: testCase.input))
            
            do {
                let ast = try parser.parse()
                XCTAssertEqual(ast.description, testCase.expected.description)
            }
            catch let error {
                XCTFail("Parser threw error on valid input: \(error)")
            }
        }
    }
    
}
