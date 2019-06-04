//: A UIKit based Playground for presenting user interface

import Foundation
import UIKit
import PlaygroundSupport

// Value is a value between 0 and 1 - percentage based
typealias Segment = (value: Double, color: UIColor)

class CircularView: UIView {
    var backgroundCircleColor: UIColor = .lightGray
    var initialDegree: CGFloat = 0
    var lineWidth: CGFloat = 8
    
    private var shapeLayer: CAShapeLayer = .init()
    
    private var backgroundCircle: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = nil
        return layer
    }()
    
    var segments: [Segment] = [(0.4, .red), (0.2, .green)] {
        didSet {
            setupView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        backgroundColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    private func setupView() {
        shapeLayer.sublayers?.removeAll()
        setupBackgroundCircle()
        setupSegments()
    }
    
    private func setupBackgroundCircle() {
        let arcCenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius = CGFloat((bounds.width/2) - lineWidth)
        let bgPath = UIBezierPath(arcCenter: arcCenter,
                                  radius: radius,
                                  startAngle: 0,
                                  endAngle: -CGFloat.pi*2,
                                  clockwise: false)
        
        backgroundCircle.path = bgPath.cgPath
        backgroundCircle.lineWidth = lineWidth
        backgroundCircle.strokeColor = backgroundCircleColor.cgColor
        layer.insertSublayer(backgroundCircle, at: 1)
    }
    
    private func setupSegments() {
        var percent: Double = 0
        
        for segment in segments {
            let segmentLayer = CAShapeLayer()
            segmentLayer.lineWidth = lineWidth
            segmentLayer.lineCap = .round
            segmentLayer.fillColor = nil
            segmentLayer.strokeColor = segment.color.cgColor
            
            let start = initialDegree + CGFloat(percent * -.pi * 2)
            let end = start + CGFloat(segment.value * -.pi * 2)
            percent += segment.value
            
            let path = makeSegment(startingAt: start, endingAt: end)
            segmentLayer.path = path.cgPath
            
            shapeLayer.addSublayer(segmentLayer)
        }
        
        layer.addSublayer(shapeLayer)
    }
    
    // Returns a UIBezierPath for segment with starting and ending degrees
    private func makeSegment(startingAt start: CGFloat, endingAt end: CGFloat) -> UIBezierPath {
        let arcCenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius = CGFloat((bounds.width/2) - lineWidth)
        
        let clockwise = false
        
        return UIBezierPath(arcCenter: arcCenter,
                                          radius: radius,
                                          startAngle: start,
                                          endAngle: end,
                                          clockwise: clockwise)
    }
}



// Present the view controller in the Live View window
PlaygroundPage.current.liveView = CircularView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
