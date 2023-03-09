//
//  Duration.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/2/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension Duration {
    func milliseconds() -> String {
        return self.formatted(.units(allowed: [.milliseconds], width: .wide))
    }
    
    func seconds() -> String {
        return self.formatted(.units(allowed: [.seconds, .milliseconds], width: .wide))
    }
}
