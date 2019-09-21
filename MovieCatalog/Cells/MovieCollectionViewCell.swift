import UIKit
import Common

class MovieCollectionViewCell: UICollectionViewCell, Configurable {

    // MARK: - Outlets
    
    @IBOutlet weak private(set) var posterImage: UIImageView!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var favoriteStatusImage: UIImageView!
    
    // MARK: - Setup
    
    func setup(with value: Movie) {
        if let url = URL(string: "http://image.tmdb.org/t/p/w185//" + (value.posterPath ?? "")) {
            UIImage.download(from: url) { [unowned self] (image, _) in
                self.posterImage.image = image
            }
        }
        titleLabel.text = value.title
        favoriteStatusImage.image = Assets.Icons.Status.favoriteGray
    }
    
}
