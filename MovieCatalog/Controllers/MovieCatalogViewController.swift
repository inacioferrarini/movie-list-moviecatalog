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

import Common
import Flow
import Ness

protocol MovieCatalogViewControllerDelegate: AnyObject {

    func movieCatalogViewController(_ movieCatalogViewController: MovieCatalogViewController, didSelected movie: Movie)

}

class MovieCatalogViewController: UIViewController, Storyboarded, AppContextAware, LanguageAware {

    // MARK: - Outlets

    @IBOutlet weak private(set) var movieCatalogView: MovieCatalogView!

    // MARK: - Properties

    weak var appContext: AppContext?
    weak var delegate: MovieCatalogViewControllerDelegate?
    let api = APIs()
    let dispatchGroup = DispatchGroup()
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Search

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var movieSearchResult = appContext?.movieList
        movieSearchResult = updateFavorites(searchResult: movieSearchResult)
        if movieSearchResult == nil {
            fetchFavoriteMoviesData()
        } else {
            movieCatalogView.movieSearchResult = movieSearchResult
        }
    }

    private func setup() {
        self.title = viewControllerTitle
        self.movieCatalogView.delegate = self
        self.movieCatalogView.appLanguage = appContext?.appLanguage
        self.setupSearchController()
        self.setupNavigationItem()
        self.setupAccessibility()
    }

    private func setupSearchController() {
        self.searchController.searchBar.barTintColor = Assets.Colors.NavigationBar.backgroundColor
        self.searchController.searchBar.setTextBackground(Assets.Colors.NavigationBar.textBackgroundColor)
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = searchPlaceholder
        self.definesPresentationContext = true
    }

    private func setupNavigationItem() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
    }

    private func setupAccessibility() {
        self.navigationItem.accessibilityLabel = self.accessibilityTitleLabel
        self.searchController.isAccessibilityElement = true
        self.searchController.accessibilityLabel = self.accessibilitySearchLabel
    }

    private func fetchFavoriteMoviesData() {
        guard let apiKey = appContext?.theMovieDbApiKey else { return }
        movieCatalogView.showLoadingView()
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            self.api.movies.popularMovies(
                apiKey: apiKey,
                page: 1,
                success: { searchResult in
                    self.handlePopularMoviesResponse(searchResult)
            }, failure: { error in
                self.handlePopularMoviesResponse(error)
            })
        }
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            self.api.genres.genres(
                apiKey: apiKey,
                success: { genres in
                    self.handleMovieGenresResponse(genres)
            }, failure: { error in
                self.handleMovieGenresResponse(error)
            })
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { [unowned self] in
            self.movieCatalogView.hideLoadingView()
        }

    }

    // MARK: - Filters

    func applyFilters() {
        guard self.movieCatalogView != nil else { return }
        if let searchText = searchController.searchBar.text, searchText.count > 0 {
            let predicate = NSPredicate(block: { (evaluatedObject, _) -> Bool in
                guard let movie = evaluatedObject as? Movie else { return false }
                return movie.title?.contains(searchText) ?? false
            })
            self.movieCatalogView.searchTextNotFoundMessage = searchWithoutResults
                .replacingOccurrences(of: ":searchExpression", with: searchText)
            self.movieCatalogView.predicate = predicate
        } else {
            self.movieCatalogView.searchTextNotFoundMessage = nil
            self.movieCatalogView.predicate = nil
        }
    }

}

extension MovieCatalogViewController: Internationalizable {

    var viewControllerTitle: String {
        return s("title")
    }

    var searchPlaceholder: String {
        return s("searchPlaceholder")
    }

    var fetchPopularMoviesErrorMessage: String {
        return s("fetchPopularMoviesErrorMessage")
    }

    var fetchGenresErrorMessage: String {
        return s("fetchGenresErrorMessage")
    }

    var searchWithoutResults: String {
        return s("searchWithoutResults")
    }

    var accessibilityTitleLabel: String {
        return s("accessibilityTitleLabel")
    }

    var accessibilitySearchLabel: String {
        return s("accessibilitySearchLabel")
    }

}

extension MovieCatalogViewController: MovieCatalogViewDelegate {

    func movieCatalogView(_ moviewCatalogView: MovieCatalogView, didSelected movie: Movie) {
        delegate?.movieCatalogViewController(self, didSelected: movie)
    }

    func movieCatalogView(_ moviewCatalogView: MovieCatalogView, requestFavoritePage page: Int) {
        guard let apiKey = appContext?.theMovieDbApiKey else { return }
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            self.api.movies.popularMovies(
                apiKey: apiKey,
                page: page,
                success: { searchResult in
                    self.handlePopularMoviesResponse(searchResult)
            }, failure: { error in
                self.handlePopularMoviesResponse(error)
            })
        }
    }

    func movieCatalogViewDidPullToRefresh(_ movieCatalogView: MovieCatalogView) {
        guard let apiKey = appContext?.theMovieDbApiKey else { return }
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            self.api.movies.popularMovies(
                apiKey: apiKey,
                page: 1,
                success: { searchResult in
                    self.handlePopularMoviesResponse(searchResult)
            }, failure: { error in
                self.handlePopularMoviesResponse(error)
            })
        }
    }

}

extension MovieCatalogViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        applyFilters()
    }

}
