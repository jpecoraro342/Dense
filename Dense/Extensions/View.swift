//
//  View.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/1/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
