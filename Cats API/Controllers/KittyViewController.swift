//
//  ViewController.swift
//  Cats API
//
//  Created by Ilya Kokorin on 25.02.2022.
//

import UIKit

class KittyViewController: UIViewController{
    
    var kittyFactManager = KittyFactManager()
    var kittyImageManager = KittyImageManager()
    
    @IBOutlet var kittyImage: UIImageView!
    @IBOutlet var kittyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kittyFactManager.delegate = self
        kittyImageManager.delegate = self
    }
    @IBAction func newFactPressed(_ sender: UIButton) {
        kittyFactManager.fetchKittyFact()
    }
    
    @IBAction func newImagePressed(_ sender: UIButton) {
        kittyImageManager.fetchKittyImage()
    }
}
//MARK: - KittyFactManagerDelegate
extension KittyViewController: KittyFactManagerDelegate{
    func didUpdateFact(_ factManager: KittyFactManager, fact: KittyFactModel)
    {
        DispatchQueue.main.async {
            self.kittyLabel.text = String(fact.kittyFact)
            
        }
    }
    func didFailedWithError(error: Error){
        print(error)
    }
}

//MARK: - KittyImageManagerDelegate
extension KittyViewController: KittyImageManagerDelegate{
    func didUpdateImage(_ imageManager: KittyImageManager, neededImageUrl: URL)
    {
        DispatchQueue.main.async {
            self.kittyImage.load(url: neededImageUrl)
            print("noice")
        }
    }
    func didImageFailedWithError(error: Error){
        print(error)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
