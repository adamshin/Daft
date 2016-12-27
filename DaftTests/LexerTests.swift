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

struct LexerTestCase {
    let input: String
    let expected: [Token]
}

struct LexerErrorCase {
    let input: String
    let error: LexerError
}

private let testCases = [
    LexerTestCase(
        input: "var foo = 42;",
        expected: [
            .varKeyword,
            .identifier("foo"),
            .binaryOperator(.assignment),
            .intLiteral("42"),
            .semicolon,
        ]
    ),
    LexerTestCase(
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
    LexerTestCase(
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
    LexerTestCase(
        input: "a(\"bc123\") \"hello   world\"",
        expected: [
            .identifier("a"),
            .leftParen,
            .stringLiteral("bc123"),
            .rightParen,
            .stringLiteral("hello   world"),
        ]
    ),
    LexerTestCase(
        input: "a=b==c < > ===;==",
        expected: [
            .identifier("a"),
            .binaryOperator(.assignment),
            .identifier("b"),
            .binaryOperator(.equality),
            .identifier("c"),
            .binaryOperator(.lessThan),
            .binaryOperator(.greaterThan),
            .binaryOperator(.equality),
            .binaryOperator(.assignment),
            .semicolon,
            .binaryOperator(.equality),
        ]
    ),
    LexerTestCase(
        input: "{ b; } { c (d)",
        expected: [
            .leftBrace,
            .identifier("b"),
            .semicolon,
            .rightBrace,
            .leftBrace,
            .identifier("c"),
            .leftParen,
            .identifier("d"),
            .rightParen,
            ]
    ),
    LexerTestCase(
        input: "if else while func var return true false void",
        expected: [
            .ifKeyword,
            .elseKeyword,
            .whileKeyword,
            .funcKeyword,
            .varKeyword,
            .returnKeyword,
            .boolLiteral(true),
            .boolLiteral(false),
            .voidLiteral,
        ]
    ),
]

private let errorCases = [
    LexerErrorCase(input: "\"hello world", error: .endOfFile),
    LexerErrorCase(input: "~", error: .unexpectedCharacter),
]

// MARK: - LexerTests

class LexerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testLexer() {
        testCases.forEach {
            let lexer = Lexer(input: LexerStringInput(string: $0.input))
            $0.expected.forEach {
                do {
                    guard let token = try lexer.nextToken() else { return XCTFail("Lexer terminated prematurely.") }
                    XCTAssertEqual($0, token, "Lexer returned incorrect token.")
                }
                catch let error {
                    XCTFail("Lexer threw error on valid input: \(error)")
                }
            }
            XCTAssertNil(try! lexer.nextToken(), "Lexer returned extra token(s).")
        }
    }
    
    func testLexerErrors() {
        errorCases.forEach {
            let lexer = Lexer(input: LexerStringInput(string: $0.input))
            do {
                while let _ = try lexer.nextToken() { }
                XCTFail("Lexer failed to throw error.")
            }
            catch let error as LexerError {
                XCTAssertEqual(error, $0.error, "Lexer threw incorrect error.")
            }
            catch {
                XCTFail("Lexer threw unrecognized error.")
            }
        }
    }
    
}
