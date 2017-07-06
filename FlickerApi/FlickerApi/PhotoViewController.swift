
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var store:PhotoStore!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        store.fetchInterestingPhotos{(result) in
            //result is [Photo]
            switch result{
            case let .success(photos):
                
                let urlImage = photos[0].remoteURL
                
                let data = try! Data(contentsOf: urlImage)

                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data)
                    self.imageView.image = image
                })
                
            case let .failure(error):
                print("Error! \(error)")

            }

            print("result")
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}
