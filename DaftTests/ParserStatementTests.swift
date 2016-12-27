//
//  ParserStatementTests.swift
//  Daft
//
//  Created by Adam Shin on 12/17/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

class ParserStatementTests: XCTestCase {
    
    func testParseStatement() {
        let testCases = [
            ParserTestCase(
                input: "foo;",
                expected: expression(binarySeries(postfix(identifier("foo"))))
            ),
            ParserTestCase(
                input: "var a;",
                expected: variableDeclaration("a", nil)
            ),
            ParserTestCase(
                input: "var b = 0;",
                expected: variableDeclaration("b", binarySeries(postfix(intLiteral("0"))))
            ),
            ParserTestCase(
                input: "if (1) { }",
                expected: ifStatement(
                    condition(
                        binarySeries(postfix(intLiteral("1")))
                    ),
                    codeBlock([])
                )
            ),
            ParserTestCase(
                input: "return;",
                expected: returnStatement()
            ),
            ParserTestCase(
                input: "return 0;",
                expected: returnStatement(binarySeries(postfix(intLiteral("0"))))
            ),
        ]
        let errorCases = [
            ParserErrorCase(input: "foo", error: .endOfFile),
            ParserErrorCase(input: "var x y;", error: .unexpectedToken),
            ParserErrorCase(input: "if 1 { }", error: .unexpectedToken),
        ]
        testParser(testCases: testCases, errorCases: errorCases) { try $0.parseStatement() }
    }
    
    func testParseIfStatement() {
        let testCases = [
            ParserTestCase(
                input: "if (1) { foo; }",
                expected: ifStatement(
                    condition(
                        binarySeries(postfix(intLiteral("1")))
                    ),
                    codeBlock([
                        expression(binarySeries(postfix(identifier("foo"))))
                    ])
                )
            ),
            ParserTestCase(
                input: "if (1) { } else { }",
                expected: ifStatement(
                    condition(
                        binarySeries(postfix(intLiteral("1")))
                    ),
                    codeBlock([]),
                    finalElse(codeBlock([]))
                )
            ),
            ParserTestCase(
                input: "if (1) { } else if (2) { } else { }",
                expected: ifStatement(
                    condition(
                        binarySeries(postfix(intLiteral("1")))
                    ),
                    codeBlock([]),
                    elseIf(ifStatement(
                        condition(
                            binarySeries(postfix(intLiteral("2")))
                        ),
                        codeBlock([]),
                        finalElse(
                            codeBlock([])
                        )
                    ))
                )
            ),
        ]
        let errorCases = [
            ParserErrorCase(input: "if 1", error: .unexpectedToken),
            ParserErrorCase(input: "if else", error: .unexpectedToken),
            ParserErrorCase(input: "if (1) { } else if", error: .endOfFile),
        ]
        testParser(testCases: testCases, errorCases: errorCases) { try $0.parseIfStatement() }
    }
    
    func testParseWhileStatement() {
        let testCases = [
            ParserTestCase(
                input: "while (1) { foo; }",
                expected: whileStatement(
                    condition(
                        binarySeries(postfix(intLiteral("1")))
                    ),
                    codeBlock([
                        expression(binarySeries(postfix(identifier("foo"))))
                    ])
                )
            ),
        ]
        let errorCases = [
            ParserErrorCase(input: "while 1", error: .unexpectedToken)
        ]
        testParser(testCases: testCases, errorCases: errorCases) { try $0.parseWhileStatement() }
    }

}
