//
//  PokemonLoadView.swift
//  PokemonSwiftUI
//
//  Created by Shwait Kumar on 26/12/24.
//

import SwiftUI

struct PokemonLoadView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(colors: [.seafoamMist, .jadeForest], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                Image("PokemonLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * (UITraitCollection.current.horizontalSizeClass == .regular ? 0.2 : 0.3), height: geometry.size.width * (UITraitCollection.current.horizontalSizeClass == .regular ? 0.1 : 0.15))
    
                VStack {
                    Spacer()
                    
                    ProgressView()
                        .controlSize(.extraLarge)
                        .tint(.mintFrost)
                        .padding()
                        .padding(.vertical)
                } //: VSTACK
            } //: ZSTACK
        }
    }
}

#Preview {
    PokemonLoadView()
}
