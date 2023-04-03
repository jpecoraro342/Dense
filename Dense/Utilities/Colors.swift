//
//  Colors.swift
//  Dense
//
//  Created by Joseph Pecoraro on 4/3/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

extension Color {
    static func systemBackground() -> Color {
        return Color(light: Color(UIColor.tertiarySystemBackground),
                     dark: Color(UIColor.secondarySystemBackground))
    }
}
