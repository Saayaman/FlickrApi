
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "photoCell"

    var store:PhotoStore!
    var photoList:[Photo]=[]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        store.fetchInterestingPhotos{(result) in
            //result is [Photo]
            switch result{
            case let .success(photos):
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.photoList = photos
                    print(self.photoList.count)
                })
                
            case let .failure(error):
                print("Error! \(error)")
            }
            print("result")
            
            self.collectionView.reloadData()
        }
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        self.collectionView.reloadData()
//
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        self.collectionView.reloadData()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



extension PhotoViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,for:indexPath) as! PhotoCell
        
        let urlImage = photoList[indexPath.row].remoteURL
        let data = try! Data(contentsOf: urlImage)
        
        let image = UIImage(data: data)
        cell.cellImageView.image = image
        
        print(data)
        return cell
    }

}

extension PhotoViewController: UICollectionViewDelegate{
    
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let length = (UIScreen.main.bounds.width-15)/4 - 10
        return CGSize(width: length,height: length*2.5/3);
    }
}
