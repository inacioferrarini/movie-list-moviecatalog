//    The MIT License (MIT)
//
//    Copyright (c) 2019 Inácio Ferrarini
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
import Ness

protocol MovieCatalogViewDelegate: AnyObject {

    func moviewCatalogView(_ moviewCatalogView: MovieCatalogView, didSelected movie: Movie)
    func moviewCatalogView(_ moviewCatalogView: MovieCatalogView, requestFavoritePage page: Int)
}

class MovieCatalogView: XibView {

    // MARK: - Outlets

    @IBOutlet weak private(set) var collectionView: UICollectionView!

    // MARK: - Private Properties

    private var dataProvider = ArrayDataProvider<Movie>(section: [])
    private var collectionViewDataSource: CollectionViewArrayDataSource<MovieCollectionViewCell, Movie>?

    // MARK: - Properties

    var movieSearchResult: MovieSearchResult? {
        didSet {
            if let movieSearchResult = movieSearchResult,
                let results = movieSearchResult.results {
                dataProvider.elements = [results]
                collectionViewDataSource?.refresh()
            }
        }
    }

    weak var delegate: MovieCatalogViewDelegate?

    var predicate: NSPredicate? {
        didSet {
            self.dataProvider.predicate = predicate
            collectionViewDataSource?.refresh()
            checkTotalResults()
        }
    }

    var searchTextNotFoundMessage: String?

    private func checkTotalResults() {
        if self.dataProvider.isFilterActive {
            var total = 0
            for elements in self.dataProvider.elements {
                total += elements.count
            }
            if total > 0 {
                self.hideNotFoundView()
            } else {
                if let message = searchTextNotFoundMessage {
                    self.showNotFoundView(message: message)
                }
            }
        } else {
            self.hideNotFoundView()
        }
    }

    // MARK: - Initialization

    override open func setupView() {
        setupCollectionView()
    }

    private func setupCollectionView() {
        let nib = UINib(nibName: MovieCollectionViewCell.simpleClassName(), bundle: Bundle(for: type(of: self)))
        collectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.simpleClassName())
        let dataSource = CollectionViewArrayDataSource<MovieCollectionViewCell, Movie>(for: collectionView, with: dataProvider)
        collectionView.dataSource = dataSource
        self.collectionViewDataSource = dataSource
        collectionView.delegate = self
    }

}

extension MovieCatalogView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataProvider[indexPath] else { return }
        delegate?.moviewCatalogView(self, didSelected: movie)
    }

    func shouldLoadNextPage() -> Bool {
        guard let movieSearchResult = self.movieSearchResult else { return false }
        guard let page = movieSearchResult.page else { return false }
        guard let totalPages = movieSearchResult.totalPages else { return false }
        return page <= totalPages
    }

    func loadNextPage() {
        guard let movieSearchResult = self.movieSearchResult else { return }
        let nextPage = (movieSearchResult.page ?? 1) + 1
        delegate?.moviewCatalogView(self, requestFavoritePage: nextPage)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height
        if endScrolling >= scrollView.contentSize.height {
            if self.shouldLoadNextPage() {
                DispatchQueue.main.async { [weak self] in
                    self?.loadNextPage()
                }
            }
        }
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
