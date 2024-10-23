//
//  Service.swift
//  Reverse Words
//
//  Created by Igor Plastun on 23.10.2024.
//

import Foundation


class Service {
    
    init(){}
    
     func reverseString(str: String?) -> String {
        guard let str = str else { return "" }
        let words = str.split(separator: " ")
        let reverseWords = words.map{String($0.reversed())}
        let reversedString = reverseWords.joined(separator: " ")
        return reversedString
    }
}
