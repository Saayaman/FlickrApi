
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
                self.photoDataSource.photoList = photos
            
            case let .failure(error):
                print("Error! \(error)")
                self.photoDataSource.photoList.removeAll()
            }
            
//            self.collectionView.reloadData()
            self.collectionView.reloadSections(IndexSet(integer:0))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension PhotoViewController: UICollectionViewDelegate{
//    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = photoDataSource.photoList[indexPath.row]
        
        
        
        store.fetchImage(for: photo){(result) in
//            //get the most recent photo! result is Photo!
            guard let photoIndex = self.photoDataSource.photoList.index(of: photo),
                case let .success(image) = result else {
                    return
            }
        
            let photoIndexPath = IndexPath(item:photoIndex, section:0)
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCell{
                cell.labe.text = "some text"
                cell.update(with: image)
            }

        }
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let length = (UIScreen.main.bounds.width-15)/4 - 10
        return CGSize(width: length,height: length*2.5/3);
    }
}
