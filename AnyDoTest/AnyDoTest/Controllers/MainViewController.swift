//
//  MainViewController.swift
//  AnyDoTest
//
//  Created by anydo on 29/04/2018.
//  Copyright © 2018 anydo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var stateSwitch: UISwitch!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    var socketNetWorkManager:SocketManager?
    
    let controllerTransition = ControllerTransition()
    
    var groceryItemArray:[GroceryItem] = []
    
    var gridLayout: GridLayout!
    lazy var listLayout: ListLayout = {
        var listLayout = ListLayout(itemHeight: 90)
        return listLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        socketNetWorkManager = SocketManager()
        
        
        gridLayout = GridLayout(numberOfColumns: 3)
        collectionView.collectionViewLayout = gridLayout
        collectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(socketDataRecived(_:)), name: .socketDataRecived, object:nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .socketDataRecived, object: nil)
    }
    
    
    @IBAction func changeGridStateClicked(_ sender: Any) {
        if stateSwitch.isOn {
            // list layout
            UIView.animate(withDuration: 0.1, animations: {
                self.stateLabel.text = "List View"
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.listLayout, animated: false)
                //                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
            })
        }else{
            // grid layout
            self.stateLabel.text = "Grid View"
            UIView.animate(withDuration: 0.1, animations: {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.gridLayout, animated: false)
                //                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
            })
        }
        
    }
    

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "transition" {
            let sampleViewController = segue.destination as! SampleViewController
            sampleViewController.transitioningDelegate = controllerTransition
        }
    }
    
    
    @objc func socketDataRecived(_ notification: Notification)
    {
        if let groceryItem = notification.userInfo?["item"] as? GroceryItem {
            
            self.collectionView?.performBatchUpdates({
                let indexPath = IndexPath(row: self.groceryItemArray.count, section: 0)
                groceryItemArray.append(groceryItem)
                self.collectionView?.insertItems(at: [indexPath])
            }, completion: nil)
        }
    }


}


extension MainViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groceryItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        var groceryItem = groceryItemArray[indexPath.row]
        cell.nameLabel.text = groceryItem.name
        cell.weightLabel.text = groceryItem.weight
        cell.bgColor.backgroundColor = UIColor(hexString: groceryItem.bgColor!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let _: SampleViewController = storyboard?.instantiateViewController(withIdentifier: "SampleViewController") as! SampleViewController
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}


extension UIColor {
    convenience init(hexString:String) {
        let hexString:NSString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}
