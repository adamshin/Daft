//
//  ParserTests.swift
//  Daft
//
//  Created by Adam Shin on 12/11/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

class ParserTests: XCTestCase {
    
    func testParse() {
        let testCases = [
            ParserTestCase(
                input: "100 + b; hi(); asdf = 3;",
                expected: [
                    expression(binarySeries([
                        postfix(intLiteral("100")),
                        postfix(identifier("b")),
                    ], [
                        binaryOperator(.addition)
                    ])),
                    expression(binarySeries(postfix(
                        identifier("hi"), [
                            functionCallArgumentList([])
                        ]
                    ))),
                    expression(binarySeries([
                        postfix(identifier("asdf")),
                        postfix(intLiteral("3")),
                    ], [
                        binaryOperator(.assignment)
                    ])),
                ]
            ),
            ParserTestCase(
                input: "var foo = bar(5);",
                expected: [
                    variableDeclaration(
                        "foo",
                        binarySeries(postfix(
                            identifier("bar"), [
                                functionCallArgumentList([
                                    binarySeries(postfix(intLiteral("5")))
                                ])
                            ]
                        ))
                    )
                ]
            ),
            ParserTestCase(
                input: "1 + (2 + 3) - 4;",
                expected: [
                    expression(
                        binarySeries([
                            postfix(intLiteral("1")),
                            postfix(parenthesized(
                                binarySeries([
                                    postfix(intLiteral("2")),
                                    postfix(intLiteral("3")),
                                ], [
                                    binaryOperator(.addition)
                                ])
                            )),
                            postfix(intLiteral("4")),
                        ], [
                            binaryOperator(.addition),
                            binaryOperator(.subtraction),
                        ])
                    )
                ]
            ),
            ParserTestCase(
                input: "if (a) { foo; bar; } else if (b) { baz; } else { spam; } zip;",
                expected: [
                    ifStatement(
                        condition(
                            binarySeries(postfix(identifier("a")))
                        ),
                        codeBlock([
                            expression(binarySeries(postfix(identifier("foo")))),
                            expression(binarySeries(postfix(identifier("bar")))),
                        ]),
                        elseIf(ifStatement(
                            condition(
                                binarySeries(postfix(identifier("b")))
                            ),
                            codeBlock([
                                expression(binarySeries(postfix(identifier("baz")))),
                            ]),
                            finalElse(
                                codeBlock([
                                    expression(binarySeries(postfix(identifier("spam"))))
                                ])
                            )
                        ))
                    ),
                    expression(binarySeries(postfix(identifier("zip")))),
                ]
            ),
        ]
        testParser(testCases: testCases, errorCases: []) { try $0.allStatements() }
    }
    
}
