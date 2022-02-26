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


