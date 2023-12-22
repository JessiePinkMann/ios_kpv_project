import UIKit

extension UIButton {
    func scaleImage(_ coef: CGFloat) {
        self.imageView?.layer.transform = CATransform3DMakeScale(coef, coef, coef)
    }
    
    func setColor(_ color: UIColor?) {
        self.tintColor = color
        self.setTitleColor(color, for: .normal)
    }
    
    func centerVertically(padding: CGFloat = 6.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
            return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: (totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
    
}

// MARK: - Class BigAreaButton
class BigAreaButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newArea = CGRect(
            x: self.bounds.origin.x - 5.0,
            y: self.bounds.origin.y - 5.0,
            width: self.bounds.size.width + 10.0,
            height: self.bounds.size.height + 20.0
        )
        return newArea.contains(point)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
