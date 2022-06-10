//
//  ViewController.swift
//  Shape2022-06-11
//
//  Created by 村中令 on 2022/06/11.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 0
    }

    @IBAction func clearTapped(_ sender: Any) {
        drawView.clear()
    }

    @IBAction func undoTapped(_ sender: Any) {
        drawView.undo()
    }

    @IBAction func colorChanged(_ sender: Any) {
        var c = UIColor.black
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            c = UIColor.green
            break
        case 2:
            c = UIColor.red
            break
        default:
            break
        }
        drawView.setDrawingColor(color: c)
    }
}

class DrawView: UIView {

    var currentDrawing: Drawing?
    var finishedDrawings: [Drawing] = []
    var currentColor = UIColor.black

    override func draw(_ rect: CGRect) {
        for drawing in finishedDrawings {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }

        if let drawing = currentDrawing {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)

        currentDrawing = Drawing(startPoint: location)
        currentDrawing?.color = currentColor
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        currentDrawing?.endPoint = location
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if var drawing = currentDrawing {
            let touch = touches.first!
            let location = touch.location(in: self)
            drawing.endPoint = location
            finishedDrawings.append(drawing)
        }
        currentDrawing = nil
        setNeedsDisplay()
    }

    func clear() {
        finishedDrawings.removeAll()
        setNeedsDisplay()
    }

    func undo() {
        if finishedDrawings.count == 0 {
            return
        }
        finishedDrawings.remove(at: finishedDrawings.count - 1)
        setNeedsDisplay()
    }

    func setDrawingColor(color : UIColor){
        currentColor = color
    }

    func stroke(drawing: Drawing) {
        let path = UIBezierPath()
        path.lineWidth = 10.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round

        let begin = drawing.startPoint
        path.move(to: begin)

        guard let end = drawing.endPoint else { return }
        path.addLine(to: end)
        path.close()
        path.stroke()
    }
}
