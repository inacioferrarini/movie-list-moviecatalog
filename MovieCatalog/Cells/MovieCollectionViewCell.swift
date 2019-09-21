import UIKit
import Common

class MovieCollectionViewCell: UICollectionViewCell, Configurable {

    // MARK: - Outlets
    
    @IBOutlet weak private(set) var posterImage: UIImageView!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var favoriteStatusImage: UIImageView!
    
    // MARK: - Setup
    
    func setup(with value: Movie) {
        if let posterImageUrl = URL(string: "http://image.tmdb.org/t/p/w185//" + (value.posterPath ?? "")) {
            DispatchQueue.global().async {
                if let posterImageData = try? Data(contentsOf: posterImageUrl) {
                    DispatchQueue.main.async {
                        self.posterImage.image = UIImage(data: posterImageData)
                    }
                }
            }
        }
        titleLabel.text = value.title
        favoriteStatusImage.image = Assets.Icons.Status.favoriteGray
    }
    
}
