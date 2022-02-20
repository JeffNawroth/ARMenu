//
//  WidthPreferenceSettingView.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 19.02.22.
//

import SwiftUI

struct WidthPreferenceSettingView: View {
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(
                    key: WidthPreferenceKey.self,
                    value: [WidthPreference(width: geometry.frame(in: CoordinateSpace.global).width)]
                )
        }
    }
}

struct WidthPreferenceSettingView_Previews: PreviewProvider {
    static var previews: some View {
        WidthPreferenceSettingView()
    }
}
