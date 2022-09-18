//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 15/09/22.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService{
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private var folderName = "coin_images"
    private let fileManeger = LocalFileManager.instance
    private var imageName: String
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getcoinImage()
    }
    
    private func getcoinImage(){
        if let savedImage = fileManeger.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
  
        guard let url = URL(string: coin.image) else { return }
        
        
        imageSubscription = Networking.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: Networking.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManeger.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}

