//
//  PDFView+Extension.swift
//  ios-pdf-edit-example
//
//  Created by 朱冰一 on 2023/10/21.
//

import Foundation
import PDFKit

extension PDFView {
    private var privateScrollView: UIScrollView? {
        return subviews.first as? UIScrollView
    }
    
    var isScrollEnabled: Bool? {
        set {
            if let newValue {
                privateScrollView?.isScrollEnabled = newValue
            }
        }
        
        get {
            privateScrollView?.isScrollEnabled
        }
    }
}
