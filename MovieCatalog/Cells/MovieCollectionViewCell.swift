import UIKit
import Common

class MovieCollectionViewCell: UICollectionViewCell, Configurable {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(with value: Movie) {
        print("MovieCollectionViewCell setup with \(value)")
    }
    
}
