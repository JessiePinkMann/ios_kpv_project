import UIKit

class BarcodeScannerRectView: UIView {
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Set the fill color to transparent
        context.setFillColor(UIColor.clear.cgColor)
        // Set the line color to white
        context.setStrokeColor(UIColor.white.cgColor)
        // Set the line width to 2
        context.setLineWidth(2)
        
        // Calculate the size of the rectangle
        let rectSize = CGSize(width: rect.width * 0.8, height: rect.height * 0.6)
        let rectOrigin = CGPoint(x: rect.midX - rectSize.width / 2, y: rect.midY - rectSize.height / 2)
        let rectRect = CGRect(origin: rectOrigin, size: rectSize)
        
        // Draw the rectangle
        context.stroke(rectRect)
    }
}
