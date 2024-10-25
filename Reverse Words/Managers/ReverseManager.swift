//
//  Service.swift
//  Reverse Words
//
//  Created by Igor Plastun on 23.10.2024.
//

import Foundation


final class ReverseManager {
    
    func reverseString(str: String?, state: Bool, ignoreSymbols: String?) -> String {
        guard let str = str else { return "" }
        let words = str.split(separator: " ")
        let ignoreSymbols = state ?  "1234567890~!@#$%^&*()_}{:>?<;,./" : ignoreSymbols
        
        func reverseWord(word: String, ingoreSymbols: String) -> String {
            var characters = Array(word)
            var left = 0
            var right = characters.count - 1
            
            while left < right {
                if ingoreSymbols.contains(characters[left]){
                    left += 1
                } else if ingoreSymbols.contains(characters[right]) {
                    right -= 1
                } else {
                    characters.swapAt(left, right)
                    left += 1
                    right -= 1
                }
            }
            return String(characters)
        }
        
        let reverseWords = words.map { reverseWord(word:String($0), ingoreSymbols: ignoreSymbols ?? "") }
        let reversedString = reverseWords.joined(separator: " ")
        return reversedString
    }
}
