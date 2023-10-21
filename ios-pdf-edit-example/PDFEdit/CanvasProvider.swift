//
//  CanvasProvider.swift
//  ios-pdf-edit-example
//
//  Created by 朱冰一 on 2023/10/21.
//

import Foundation
import PDFKit

final class CanvasProvider: NSObject, PDFPageOverlayViewProvider {
    private var pageToCanvasViewMapping = [PDFPage: CanvasView]()

    func pdfView(_ view: PDFView, overlayViewFor page: PDFPage) -> UIView? {
        let canvasView: CanvasView
        
        if let view = pageToCanvasViewMapping[page] {
            canvasView = view
        } else {
            let view = CanvasView()
            view.isUserInteractionEnabled = true
            pageToCanvasViewMapping[page] = view
            canvasView = view
        }

        for subView in view.documentView?.subviews ?? [] {
            if subView.theClassName == "PDFPageView" {
                subView.isUserInteractionEnabled = true
            }
        }

        (page as? CanvasPDFPage)?.canvasView = canvasView
        return canvasView
    }

    func pdfView(_ pdfView: PDFView, willDisplayOverlayView overlayView: UIView, for page: PDFPage) {
    }

    func pdfView(_ pdfView: PDFView, willEndDisplayingOverlayView overlayView: UIView, for page: PDFPage) {
    }

    func endEdit() {
        pageToCanvasViewMapping.values.forEach {
            $0.isUserInteractionEnabled = false
        }
       
    }
    
    func startEdit() {
        pageToCanvasViewMapping.values.forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    
    func save() {
        for (page, canvas) in pageToCanvasViewMapping {
            if let annotation = canvas.exportPathAnnotation() {
                canvas.resetCanvas()
                page.addAnnotation(annotation)
            }
        }
    }
}
