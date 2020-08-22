import Foundation
import UIKit

extension UIView {
    func clearWhiteGradient() {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0.7).cgColor]
        self.layer.addSublayer(gradientLayer)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) -> CALayer {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        return border
    }
}
