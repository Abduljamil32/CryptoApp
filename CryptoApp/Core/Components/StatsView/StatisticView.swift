//
//  StatisticView.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 17/09/22.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticsModel
    
    var body: some View {
        VStack{
            Text(stat.title)
                .foregroundColor(Color.theme.secondaryText)
                .font(.caption)
            Text(stat.value)
                .foregroundColor(Color.theme.accent)
                .font(.headline)
            HStack(spacing: 4){
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(stat: dev.stat1 )
            .previewLayout(.sizeThatFits)
    }
}
