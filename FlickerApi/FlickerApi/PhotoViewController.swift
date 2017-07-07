
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var store:PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = photoDataSource
        
        store.fetchInterestingPhotos{(result) in
            //result is [Photo]
            switch result{
            case let .success(photos):
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.photoDataSource.photoList = photos
                })
            
            case let .failure(error):
                print("Error! \(error)")
            }
            
            self.collectionView.reloadData()
//            self.collectionView.reloadSections(IndexSet())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
