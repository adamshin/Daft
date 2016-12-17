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
    
    while true {
        print("> ", terminator: "")
        
        do {
            let input = readLine() ?? ""
            
            let lexer = Lexer(input: LexerStringInput(string: input))
            let tokens = try lexer.lex()
            
            let parser = Parser(input: ParserArrayInput(tokens: tokens))
            let ast = try parser.parse()
            
            print(ast.description)
        }
        catch let error as LexerError {
            print("Error lexing input: \(error)")
        }
        catch let error as ParserError {
            print("Error parsing input: \(error)")
        }
        catch {
            print("Unexpected error.")
        }
    }
}

repl()
