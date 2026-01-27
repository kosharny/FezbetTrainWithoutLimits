import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func standardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    func glow(color: Color = .yellow, radius: CGFloat = 20) -> some View {
        self.shadow(color: color.opacity(0.5), radius: radius, x: 0, y: 0)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension Color {
    // Utility for shifting HSBA
    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> Color {
        // Simple placeholder for adjustment in SwiftUI native if UIColor is not preferred
        // Using UIColor for easier HSB manipulation
        let uiColor = UIColor(self)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return Color(hue: h, saturation: s, brightness: min(b + percentage / 100, 1.0), opacity: a)
    }
}
