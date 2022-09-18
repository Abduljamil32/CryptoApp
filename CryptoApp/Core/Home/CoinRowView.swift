//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 14/09/22.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHolding: Bool
    
    var body: some View {
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .foregroundColor(Color.theme.secondaryText)
                .font(.headline)
                .frame(minWidth: 30)
           CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
            Spacer()
            
            if showHolding{
                VStack(alignment: .trailing ){
                    Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                        .bold()
                    Text((coin.currentHoldings ?? 0).asNumberString())
                }
                .foregroundColor(Color.theme.accent)
            }
            
            VStack(alignment: .trailing){
                Text(coin.currentPrice.asCurrencyWith6Decimals())
                    .bold()
                    .foregroundColor(Color.theme.accent)
                Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                    .foregroundColor(
                       (coin.priceChangePercentage24H ?? 0) >= 0 ?
                       Color.theme.green : Color.theme.red
                    )
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHolding: true)
    }
}
