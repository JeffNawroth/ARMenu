//
//  WidthPreferenceKey.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 19.02.22.
//

import Foundation
import SwiftUI

struct WidthPreferenceKey: PreferenceKey {
    typealias Value = [WidthPreference]
    
    static var defaultValue: [WidthPreference] = []
    
    static func reduce(value: inout [WidthPreference], nextValue: () -> [WidthPreference]) {
        value.append(contentsOf: nextValue())
    }
}

struct WidthPreference: Equatable {
    let width: CGFloat
}
