//
//  PDFDrawGestureRecognizer.swift
//  ios-pdf-edit-example
//
//  Created by 朱冰一 on 2023/10/21.
//

import Foundation
import UIKit

protocol PDFDrawGestureRecognizerDelegate: AnyObject {
    func didUpdateEditingPath(path: UIBezierPath)
    func didFinishEditingPath(path: UIBezierPath)
}

final class PDFDrawGestureRecognizer: UIGestureRecognizer {
    private var editingPath: UIBezierPath?
    weak var editPathDelegate: PDFDrawGestureRecognizerDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event!)
        
        if let touch = touches.first,touch.type == .direct,
           let numberOfTouches = event?.allTouches?.count,
           numberOfTouches == 1 {
            state = .began
            let location = touch.location(in: self.view)
            gestureRecognizerBegan(location)
        } else {
            state = .failed
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .changed
        guard let location = touches.first?.location(in: self.view) else { return }
        gestureRecognizerMoved(location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self.view) else  {
            state = .ended
            return
        }
        gestureRecognizerEnded(location)
        state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .failed
    }
}

extension PDFDrawGestureRecognizer {
    func gestureRecognizerBegan(_ location: CGPoint) {
        editingPath = UIBezierPath()
        editingPath?.lineJoinStyle = .round
        editingPath?.lineCapStyle = .round
        editingPath?.move(to: location)
    }
    
    func gestureRecognizerMoved(_ location: CGPoint) {
        guard let path = editingPath else { return }
        path.addLine(to: location)
        path.move(to: location)
        editPathDelegate?.didUpdateEditingPath(path: path)
    }
    
    func gestureRecognizerEnded(_ location: CGPoint) {
        guard let path = editingPath else { return }
        path.addLine(to: location)
        path.move(to: location)
        editPathDelegate?.didFinishEditingPath(path: path)
    }
}
