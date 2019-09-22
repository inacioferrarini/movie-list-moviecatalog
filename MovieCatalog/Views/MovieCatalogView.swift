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

protocol MovieCatalogViewDelegate: AnyObject {

    func moviewCatalogView(_ moviewCatalogView: MovieCatalogView, didSelected movie: Movie)

}

class MovieCatalogView: UIView {


    // MARK: - Outlets

    @IBOutlet weak private(set) var contentView: UIView!
    @IBOutlet weak private(set) var searchBar: UISearchBar!
    @IBOutlet weak private(set) var collectionView: UICollectionView!


    // MARK: - Private Properties

    private var dataProvider = ArrayDataProvider<Movie>(section: [])
    private var dataSource: CollectionViewArrayDataSource<MovieCollectionViewCell, Movie>?


    // MARK: - Properties

    var searchResult: MovieSearchResult? {
        didSet {
            if let searchResult = searchResult {
                dataProvider.elements = [searchResult.results]
                dataSource?.refresh()
            }
        }
    }

    weak var delegate: MovieCatalogViewDelegate?


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
        setupSearchField()
        setupCollectionView()
    }

    private func setupSearchField() {
        searchBar.barTintColor = Assets.Colors.NavigationBar.backgroundColor
        searchBar.setTextBackground(Assets.Colors.NavigationBar.textBackgroundColor)
        searchBar.showsCancelButton = false
        searchBar.showsSearchResultsButton = false
        searchBar.delegate = self
        searchBar.placeholder = "Search"
    }

    private func setupCollectionView() {
        let nib = UINib(nibName: MovieCollectionViewCell.simpleClassName(), bundle: Bundle(for: type(of: self)))
        collectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.simpleClassName())
        let dataSource = CollectionViewArrayDataSource<MovieCollectionViewCell, Movie>(for: collectionView, with: dataProvider)
        collectionView.dataSource = dataSource
        self.dataSource = dataSource
        collectionView.delegate = self
    }

}

extension MovieCatalogView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataProvider[indexPath] else { return }
        delegate?.moviewCatalogView(self, didSelected: movie)
    }

}

extension MovieCatalogView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let margin = CGFloat(30)
        let width = (self.collectionView.bounds.width - margin) / 2
        let height = width * 1.25
        return CGSize(width: width, height: height)
    }

}

extension MovieCatalogView: UISearchBarDelegate {

}
