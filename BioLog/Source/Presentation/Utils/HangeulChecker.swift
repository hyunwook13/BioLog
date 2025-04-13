//
//  HangeulChecker.swift
//  BioLog
//
//  Created by 이현욱 on 4/7/25.
//

import Foundation

// https://gist.github.com/kimjiwook/26fba39794bbc90a2cfd3de9ba16ec4f

struct HanguelChecker {
    private static let hangeul = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
    
    static func chosungCheck(word: String) -> String {
        var result = ""
        
        for char in word {
            // unicodeScalars: 유니코드 스칼라 값의 모음으로 표현되는 문자열 값
            let octal = char.unicodeScalars[char.unicodeScalars.startIndex].value
            // ~=: 왼쪽에서 정의한 범위 값 안에 오른쪽의 값이 속하면 true, 아니면 false 반환
            if 44032...55203 ~= octal {
                let index = (octal - 0xac00) / 28 / 21
                result = result + hangeul[Int(index)]
            }
        }
        return result
    }
    
    static func isChosung(word: String) -> Bool {
        var isChosung = false
        for char in word {
            if 0 < hangeul.filter({ $0.contains(char)}).count {
                isChosung = true
            } else {
                isChosung = false
                break
            }
        }
        return isChosung
    }
}
