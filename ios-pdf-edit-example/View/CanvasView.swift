//
//  CanvasView.swift
//  ios-pdf-edit-example
//
//  Created by 朱冰一 on 2023/10/21.
//

import Foundation
import UIKit
import PDFKit

final class CanvasView: UIView {
    private var editFinishedPath: UIBezierPath?
    
    private let editingLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.orange.cgColor
        layer.lineWidth = 3
        layer.fillColor = nil
        return layer
    }()
    
    private lazy var drawGesture: PDFDrawGestureRecognizer = {
        let gesture = PDFDrawGestureRecognizer()
        gesture.editPathDelegate = self
        return gesture
    }()
    
    init() {
        super.init(frame: .zero)
        layer.addSublayer(editingLayer)
        addGestureRecognizer(drawGesture)
        clipsToBounds = true
    }
    
    func exportPathAnnotation() -> PDFAnnotation? {
        guard let path = editFinishedPath else { return nil }
        return PathAnnotation(bounds: bounds, path: path)
    }
    
    func resetCanvas() {
        editFinishedPath = nil
        editingLayer.path = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        editingLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CanvasView: PDFDrawGestureRecognizerDelegate {
    func didUpdateEditingPath(path: UIBezierPath) {
        editingLayer.path = path.cgPath
    }
    
    func didFinishEditingPath(path: UIBezierPath) {
        editingLayer.path = path.cgPath
        editFinishedPath = path
    }
}
