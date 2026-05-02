import SwiftUI

enum MiraColors {
    static let background = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.10, green: 0.09, blue: 0.08, alpha: 1.0)
        : UIColor(red: 0.97, green: 0.94, blue: 0.88, alpha: 1.0)
    })

    static let surface = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.16, green: 0.14, blue: 0.13, alpha: 1.0)
        : UIColor(red: 1.00, green: 0.98, blue: 0.93, alpha: 1.0)
    })

    static let textPrimary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.93, green: 0.89, blue: 0.82, alpha: 1.0)
        : UIColor(red: 0.18, green: 0.15, blue: 0.12, alpha: 1.0)
    })

    static let textSecondary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.68, green: 0.62, blue: 0.55, alpha: 1.0)
        : UIColor(red: 0.46, green: 0.39, blue: 0.32, alpha: 1.0)
    })

    static let accent = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.83, green: 0.61, blue: 0.43, alpha: 1.0)
        : UIColor(red: 0.63, green: 0.32, blue: 0.18, alpha: 1.0)
    })

    static let border = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.30, green: 0.26, blue: 0.22, alpha: 1.0)
        : UIColor(red: 0.86, green: 0.78, blue: 0.66, alpha: 1.0)
    })
}
