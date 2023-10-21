//
//  CanvasPDFViewController.swift
//  ios-pdf-edit-example
//
//  Created by 朱冰一 on 2023/10/21.
//

import Foundation
import UIKit
import PDFKit

final class CanvasPDFViewController: UIViewController {
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        let menuButton = UIBarButtonItem(title: "Menu", image: nil, target: nil, action: nil, menu: createMenu())
        toolBar.items = [menuButton]
        return toolBar
    }()
    
    private let pdfView = PDFView()
    private let canvasProvider = CanvasProvider()
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let documentURL: URL
    
    init(fileURL: URL) {
        self.documentURL = fileURL
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPDFView()
        setupBottomMenu()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = .white
    }
    
    private func setupBottomMenu() {
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupPDFView() {
        pdfView.pageOverlayViewProvider = canvasProvider
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let document = PDFDocument(url: documentURL)
        document?.delegate = self
        pdfView.document = document
        
        pdfView.displayMode = .singlePageContinuous
        pdfView.usePageViewController(false)
        pdfView.displayDirection = .vertical
        
        pdfView.autoScales = true
        pdfView.pageShadowsEnabled = false
        pdfView.isInMarkupMode = true
        pdfView.isScrollEnabled = false
    }
    
    private func createMenu() -> UIMenu {
        let startEditAction = UIAction(title: "Start Edit") { [weak self] _ in
            self?.startEdit()
        }
        let endEditAction = UIAction(title: "End Edit") { [weak self] _ in
            self?.endEdit()
        }
        let saveAction = UIAction(title: "Save") { [weak self] _ in
            self?.savePDF()
        }
        
        return UIMenu(children: [
            startEditAction,
            endEditAction,
            saveAction
        ])
    }
    
    private func startEdit() {
        pdfView.isScrollEnabled = false
        canvasProvider.startEdit()
    }
    
    private func endEdit() {
        pdfView.isScrollEnabled = true
        canvasProvider.endEdit()
    }
    
    private func savePDF() {
        canvasProvider.save()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let fileURL = documentDirectory.appendingPathComponent("\(dateFormat.string(from: Date())).pdf")
        pdfView.document?.write(to: fileURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CanvasPDFViewController: PDFDocumentDelegate {
    func classForPage() -> AnyClass {
        return CanvasPDFPage.self
    }
}
