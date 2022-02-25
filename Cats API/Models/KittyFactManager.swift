//
//  KittyFactManager.swift
//  Cats API
//
//  Created by Ilya Kokorin on 25.02.2022.
//

import Foundation

protocol KittyFactManagerDelegate{
    
    func didUpdateFact(_ factManager: KittyFactManager, fact: KittyFactModel)
    func didFailedWithError(error: Error)
}

struct KittyFactManager {
    
    var delegate: KittyFactManagerDelegate?
    func fetchKittyFact(){
        let kittyFactUrl = "https://catfact.ninja/fact"
        performRequest(with: kittyFactUrl)
    }
    
    func performRequest(with kittyFactUrl: String){
        
        if let url = URL(string: kittyFactUrl){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailedWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let kittyFact = parseJSON(safeData){
                        self.delegate?.didUpdateFact(self, fact: kittyFact)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ kittyFactData: Data) -> KittyFactModel? {
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(KittyData.self, from: kittyFactData)
            let gotFact = decodedData.fact
            let gotLength = decodedData.length
            print(gotLength)
            if gotLength < 220{
                let fact = KittyFactModel(kittyFact: gotFact, kittyFactLength: gotLength)
                return fact
            } else {
                fetchKittyFact()
            }
            return nil
           
        } catch {
            
            return nil
        }
    }
}
