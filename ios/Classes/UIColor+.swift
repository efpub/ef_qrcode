import UIKit

extension UIColor {

    convenience init(valueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    convenience init?(valueRGBString: String?, alpha: CGFloat = 1.0) {
        if let intString = valueRGBString?.replacingOccurrences(of: "#", with: "") {
            guard let hex = UInt(intString, radix: 16) else {
                return nil
            }
            self.init(valueRGB: hex, alpha: alpha)
        } else {
            return nil
        }
    }
}
