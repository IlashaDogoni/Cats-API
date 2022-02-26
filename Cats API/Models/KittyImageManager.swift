//
//  KittyImageManager.swift
//  Cats API
//
//  Created by Ilya Kokorin on 26.02.2022.
//

import Foundation

protocol KittyImageManagerDelegate{
    func didUpdateImage(_ imageManager: KittyImageManager, neededImageUrl: URL)
    func didImageFailedWithError(error: Error)
}

struct KittyImageManager{
    
    var delegate: KittyImageManagerDelegate?
    
    func fetchKittyImage(){
        let kittyImageUrl = "https://api.thecatapi.com/v1/images/search"
        performRequest(with: kittyImageUrl)
    }
    
    func performRequest(with kittyImageUrl: String){
        if let url = URL(string: kittyImageUrl){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didImageFailedWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let currentKittyImageUrl = parseJSON(safeData){
                        self.delegate?.didUpdateImage(self, neededImageUrl: URL(string: currentKittyImageUrl.kittyImageUrl)!)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ kittyImageData: Data) -> KittyImageModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([KittyImageData].self, from: kittyImageData)
            let gotImageUrl = decodedData.first!.url
            print(gotImageUrl)
            let imageUrl = KittyImageModel(kittyImageUrl: gotImageUrl)
            print(imageUrl)
            return imageUrl
        } catch {
            print("error O_o", error)
            return nil
        }
    }
}
