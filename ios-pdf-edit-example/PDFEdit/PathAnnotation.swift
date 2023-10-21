//
//  PathAnnotation.swift
//  ios-pdf-edit-example
//
//  Created by 朱冰一 on 2023/10/21.
//

import Foundation
import PDFKit

final class PathAnnotation: PDFAnnotation{
    var path: UIBezierPath
    var stencilColor: UIColor = UIColor.orange
    var stencilWidth: CGFloat = 3
    
    init(bounds: CGRect, path: UIBezierPath) {
        self.path = path
        super.init(bounds: bounds, forType: .ink, withProperties: nil)
    }
    
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        let localPath = path.copy() as! UIBezierPath
        super.draw(with: box, in: context)
        UIGraphicsPushContext(context)
        context.saveGState()
        context.concatenate(CGAffineTransformMake(1, 0, 0, -1, 0.0, 2 * bounds.origin.y + bounds.size.height))
        localPath.lineWidth = stencilWidth
        stencilColor.setStroke()
        localPath.stroke(with: CGBlendMode.sourceOut, alpha: 1.0)
        
        context.restoreGState()
        UIGraphicsPopContext()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
