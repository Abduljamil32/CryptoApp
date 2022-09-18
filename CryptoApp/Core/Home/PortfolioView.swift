//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 17/09/22.
//

import SwiftUI
import CoreData

struct PortfolioView: View {
    @Environment(\.presentationMode) var presentetion
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment:.leading, spacing: 0){
                    SearchView(searchText: $vm.searchText)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10){
                            ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                                CoinScrollView(coin: coin)
                                    .frame(width: 75)
                                    .padding(4)
                                    .onTapGesture {
                                        withAnimation(.easeIn){
                                            updateSelectredCoin(coin: coin)
                                        }
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                selectedCoin?.id == coin.id ? Color.theme.green : Color.clear
                                                , lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.vertical, 4).padding(.leading)
                    }
                    
                    if selectedCoin != nil{
                        VStack{
                            HStack{
                                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                                Spacer()
                                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                            }
                            Divider()
                            HStack{
                                Text("Amount in your portfolio:")
                                Spacer()
                                TextField("Ex: 4", text: $quantityText)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                            }
                            Divider()
                            HStack{
                                Text("Current  value:")
                                Spacer()
                                Text(getCurrentValue().asCurrencyWith2Decimals())
                            }
                        }.padding()
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        presentetion.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark")
                            .opacity(showCheckmark ? 1.0 : 0.0)
                        Button(action: {
                            saveButtonPressed()
                        }, label: {
                            Text("SAVE")
                                .font(.headline)
                        })
                        .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0)
                    }.font(.headline)
                    
                }
            })
            .onChange(of: vm.searchText, perform: { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            })
            
        }
    }
    
    private func updateSelectredCoin(coin: CoinModel){
        selectedCoin = coin
        if let portfolioCoins = vm.portfolioCoins.first(where: { $0.id == coin.id }), let amount = portfolioCoins.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed(){
        
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }
        
        vm.uptadePortfolio(coin: coin, amount: amount)
         
        withAnimation(.easeIn){
            showCheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut){
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}


