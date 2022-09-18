//
//  CoinScrollView.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 17/09/22.
//

import SwiftUI

struct CoinScrollView: View {
    
    let coin: CoinModel
    
    var body: some View {
        VStack{
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .lineLimit(1)
                .foregroundColor(Color.theme.accent)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CoinScrollView(coin: dev.coin)
    }
}
