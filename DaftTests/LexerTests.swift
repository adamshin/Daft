//
//  LexerTests.swift
//  DaftTests
//
//  Created by Adam Shin on 12/7/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

// MARK: - Test Cases

private let testCases: [(input: String, expected: [Token])] = [
    (
        input: "var foo = 42;",
        expected: [
            .varKeyword,
            .identifier("foo"),
            .assign,
            .intLiteral("42"),
            .semicolon,
        ]
    ),
    (
        input: "(123+45) - 6 + 78",
        expected: [
            .leftParen,
            .intLiteral("123"),
            .binaryOperator(.addition),
            .intLiteral("45"),
            .rightParen,
            .binaryOperator(.subtraction),
            .intLiteral("6"),
            .binaryOperator(.addition),
            .intLiteral("78"),
        ]
    ),
    (
        input: "func   asdf_jkl(a,b)\n\n {}  ",
        expected: [
            .funcKeyword,
            .identifier("asdf_jkl"),
            .leftParen,
            .identifier("a"),
            .comma,
            .identifier("b"),
            .rightParen,
            .leftBrace,
            .rightBrace,
        ]
    ),
    (
        input: "a(\"bc123\") \"hello   world\"",
        expected: [
            .identifier("a"),
            .leftParen,
            .stringLiteral("bc123"),
            .rightParen,
            .stringLiteral("hello   world"),
        ]
    ),
    (
        input: "a=b==c < > ===;==",
        expected: [
            .identifier("a"),
            .assign,
            .identifier("b"),
            .binaryOperator(.equality),
            .identifier("c"),
            .binaryOperator(.lessThan),
            .binaryOperator(.greaterThan),
            .binaryOperator(.equality),
            .assign,
            .semicolon,
            .binaryOperator(.equality),
        ]
    ),
]

private let errorCases: [(input: String, error: LexerError)] = [
    (input: "\"hello world", error: .endOfFile),
    (input: "~", error: .unexpectedCharacter),
]

// MARK: - LexerTests

class LexerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testLexer() {
        testCases.forEach { testCase in
            let lexer = Lexer(input: LexerStringInput(string: testCase.input))
            testCase.expected.forEach {
                do {
                    guard let token = try lexer.nextToken() else { return XCTFail("Lexer terminated prematurely.") }
                    XCTAssertEqual($0, token, "Lexer returned incorrect token.")
                }
                catch let error as LexerError {
                    XCTFail("Lexer threw error on valid input: \(error)")
                }
                catch {
                    XCTFail("Lexer threw unrecognized error.")
                }
            }
            XCTAssertNil(try! lexer.nextToken(), "Lexer returned extra token(s).")
        }
    }
    
    func testLexerErrors() {
        errorCases.forEach { errorCase in
            let lexer = Lexer(input: LexerStringInput(string: errorCase.input))
            do {
                while let _ = try lexer.nextToken() { }
                XCTFail("Lexer failed to throw error.")
            } catch let error as LexerError {
                XCTAssertEqual(error, errorCase.error, "Lexer threw incorrect error.")
            } catch {
                XCTFail("Lexer threw unexpected error object.")
            }
        }
    }
    
}
