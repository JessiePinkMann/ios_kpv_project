import UIKit

extension CALayer {
    func applyShadow(_ radius: CGFloat? = nil) {
//        self.cornerRadius = radius ?? self.frame.width / 2
        self.shadowColor = UIColor.darkGray.cgColor
        self.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.shadowRadius = 4.0
        self.shadowOpacity = 0.4
        self.masksToBounds = false
    }
}
