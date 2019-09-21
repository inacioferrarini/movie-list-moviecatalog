import UIKit
import Common

protocol MovieDetailsViewDelegate: AnyObject {
    
    func movieDetailsView(_ moviewDetailsView: MovieDetailsView, didFavorite movie: Movie)
    
}

class MovieDetailsView: UIView {

    // MARK: - Outlets
    
    @IBOutlet weak private(set) var contentView: UIView!
    @IBOutlet weak private(set) var posterImage: UIImageView!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var releaseDateLabel: UILabel!
    @IBOutlet weak private(set) var genresLabel: UILabel!
    @IBOutlet weak private(set) var overviewLabel: UILabel!
    @IBOutlet weak private(set) var favoriteButton: UIButton!
    
    // MARK: - Private Properties
    
    private var isFavorite = false
    
    // MARK: - Properties
    
    var movie: Movie? {
        didSet {
            setup(with: movie)
        }
    }
    
    weak var delegate: MovieDetailsViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let className = String(describing: type(of: self))
        bundle.loadNibNamed(className, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: -
    
    private func setup(with movie: Movie?) {
        guard let movie = movie else { return }
        
//        posterImage =  movie.posterPath -- logic for cache and downloading the poster
        if let posterImageUrl = URL(string: "http://image.tmdb.org/t/p/w500//" + (movie.posterPath ?? "")) {
            DispatchQueue.global().async {
                if let posterImageData = try? Data(contentsOf: posterImageUrl) {
                    DispatchQueue.main.async {
                        self.posterImage.image = UIImage(data: posterImageData)
                    }
                }
            }
        }

        titleLabel.text = movie.title ?? ""
        
        updateFavoriteButton()
        
        releaseDateLabel.text = ""
        if let year = movie.releaseDate?.toDate()?.year {
            releaseDateLabel.text = "\(year)"
        }
        
        genresLabel.text = ""
        if let genres = movie.genreIds {
            genresLabel.text = String(describing: genres)
        }
        
        overviewLabel.text = movie.overview ?? ""
    }
    
    func updateFavoriteButton() {
        let favoriteImage = self.isFavorite
            ? Assets.Icons.Status.favoriteFull?.withRenderingMode(.alwaysOriginal)
            : Assets.Icons.Status.favoriteGray?.withRenderingMode(.alwaysOriginal)
        favoriteButton.setImage(favoriteImage, for: .normal)
    }
    
    // MARK: - Action
    
    @IBAction func favorite() {
        self.isFavorite = !isFavorite
        updateFavoriteButton()
    }
    
}
