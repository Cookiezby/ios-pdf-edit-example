//
//  NSObject+Extension.swift
//  ios-pdf-edit-example
//
//  Created by 朱冰一 on 2023/10/21.
//

import Foundation

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}
