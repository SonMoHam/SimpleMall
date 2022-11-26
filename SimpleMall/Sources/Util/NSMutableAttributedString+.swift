//
//  NSMutableAttributedString+.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import UIKit

extension NSMutableAttributedString {
    /**
     전체 또는 특정 문자열 색상 적용
     
     - parameter color: 적용할 색상
     - parameter string: 특정 문자열, default nil, nil일 경우 전체 문자열 색상 적용
     
     **Example**
     ~~~
     let attributed = NSMutableAttributedString(string: fullText)
        .color(someColor, string: targetText)
     ~~~
     */
    func color(_ color: UIColor?, string: String? = nil) -> NSMutableAttributedString {
        let target = string ?? self.string
        self.addAttribute(
            .foregroundColor,
            value: color ?? .black,
            range: range(of: target)
        )
        return self
    }
    
    private func range(of text: String) -> NSRange {
        return (self.string as NSString).range(of: text)
    }
}
