//
//  main.swift
//  Daft
//
//  Created by Adam Shin on 12/7/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

func repl() {
    print("Daft")
    
    let lexerInput = LexerLiveInput() {
        print("  > ", terminator: "")
        return readLine() ?? ""
    }
    let lexer = Lexer(input: lexerInput)
    
    let parserInput = ParserLexerInput(lexer: lexer)
    let parser = Parser(input: parserInput)
    
    do {
        let statements = try parser.allStatements()
        print(String(describing: statements))
    }
    catch let error {
        NSLog("Error parsing input: \(error)")
    }
}

repl()
