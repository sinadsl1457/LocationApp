//
//  String+Extension.swift
//  MyLocationApp
//
//  Created by 황신택 on 2022/03/23.
//

import Foundation

extension String {
    mutating func add(
        text: String?,
        separatedBy separator: String = ""
    ) {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
