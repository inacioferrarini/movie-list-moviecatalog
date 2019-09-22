//    The MIT License (MIT)
//
//    Copyright (c) 2017 Inácio Ferrarini
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

import UIKit
import Common

protocol MovieDetailsViewDelegate: AnyObject {

    func movieDetailsView(_ moviewDetailsView: MovieDetailsView, favorite: Bool, for movie: Movie)

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

    ///
    /// Initializes the view with using `UIScreen.main.bounds` as frame.
    ///
    public required init() {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }

    ///
    /// Initializes the view with using the given `frame`.
    /// - Parameter frame: Initial view dimensions.
    ///
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    ///
    /// Initializes the view with using the given `coder`.
    /// - Parameter aDecoder: NSCoder to be used.
    ///
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

        if let url = URL(string: "http://image.tmdb.org/t/p/w500//" + (movie.posterPath ?? "")) {
            UIImage.download(from: url) { [unowned self] (image, _) in
                self.posterImage.image = image
            }
        }

        titleLabel.text = movie.title ?? ""

        updateFavoriteButton()

        releaseDateLabel.text = ""
        if let year = movie.releaseDate?.toDate()?.year {
            releaseDateLabel.text = "\(year)"
        }

        genresLabel.text = ""
        if let genres = movie.genreNames {
            genresLabel.text = genres
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
        if let movie = movie {
            self.delegate?.movieDetailsView(self, favorite: self.isFavorite, for: movie)
        }
    }

}
