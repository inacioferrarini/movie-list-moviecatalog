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

class MovieCatalogViewController: UIViewController, Storyboarded {

    // MARK: - Outlets

    @IBOutlet weak private(set) var movieCatalogView: MovieCatalogView!

    // MARK: - Properties

    weak var appContext: AppContext?
    weak var delegate: MovieCatalogViewControllerDelegate?
    let api = APIs()
    let apiKey = "389b2710a34413b185b37464a7cc60ce"
    let dispatchGroup = DispatchGroup()
    let searchBarController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var movieSearchResult: MovieListSearchResultType? = appContext?.get(key: MovieListSearchResultKey)
        movieSearchResult = updateFavorites(searchResult: movieSearchResult)
        if movieSearchResult == nil {
            fetchFavoriteMoviesData()
        } else {
            let results: MovieListSearchResultType? = appContext?.get(key: MovieListSearchResultKey)
            applyMovieFilter(expression: self.searchBarController.searchBar.text, on: results)
        }
    }

    private func setup() {
        self.title = viewControllerTitle
        self.movieCatalogView.delegate = self
        self.setupSearchField()
    }

    private func setupSearchField() {
        self.navigationItem.searchController = searchBarController
        self.navigationItem.hidesSearchBarWhenScrolling = false

        self.searchBarController.searchBar.barTintColor = Assets.Colors.NavigationBar.backgroundColor
        self.searchBarController.searchBar.setTextBackground(Assets.Colors.NavigationBar.textBackgroundColor)
        self.searchBarController.searchBar.showsCancelButton = false
        self.searchBarController.searchBar.showsSearchResultsButton = false
        self.searchBarController.searchBar.delegate = self
        self.searchBarController.searchBar.placeholder = searchPlaceholder
    }

    private func fetchFavoriteMoviesData() {
        movieCatalogView.showLoadingView()
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            self.api.movies.popularMovies(
                apiKey: self.apiKey,
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
                apiKey: self.apiKey,
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
    
    func applyMovieFilter(expression: String?, on results: MovieListSearchResultType?) {
        guard let expression = expression, expression.count > 0 else {
            movieCatalogView.movieSearchResult = results
            movieCatalogView.hideNotFoundView()
            return
        }

        var filteredMovies: [Movie] = []
        if let movies = results?.results?.filter({ return $0.title?.contains(expression) ?? false }) {
            filteredMovies = movies
        }

        if filteredMovies.count > 0 {
            var results = results
            results?.results = filteredMovies
            movieCatalogView.movieSearchResult = results
            movieCatalogView.hideNotFoundView()
        } else {
            let message = searchWithoutResults
                .replacingOccurrences(of: ":searchExpression", with: expression)
            movieCatalogView.showNotFoundView(message: message)
        }
    }

}

extension MovieCatalogViewController: Internationalizable {

    var viewControllerTitle: String {
        return string("title", languageCode: "en-US")
    }

    var searchPlaceholder: String {
        return string("searchPlaceholder", languageCode: "en-US")
    }

    var fetchPopularMoviesErrorMessage: String {
        return string("fetchPopularMoviesErrorMessage", languageCode: "en-US")
    }

    var fetchGenresErrorMessage: String {
        return string("fetchGenresErrorMessage", languageCode: "en-US")
    }

    var searchWithoutResults: String {
        return string("searchWithoutResults", languageCode: "en-US")
    }

}

extension MovieCatalogViewController: MovieCatalogViewDelegate {

    func moviewCatalogView(_ moviewCatalogView: MovieCatalogView, didSelected movie: Movie) {
        delegate?.movieCatalogViewController(self, didSelected: movie)
    }

    func moviewCatalogView(_ moviewCatalogView: MovieCatalogView, requestFavoritePage page: Int) {
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            self.api.movies.popularMovies(
                apiKey: self.apiKey,
                page: page,
                success: { searchResult in
                    self.handlePopularMoviesResponse(searchResult)
            }, failure: { error in
                    self.handlePopularMoviesResponse(error)
            })
         }
    }

}

extension MovieCatalogViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let results: MovieListSearchResultType? = appContext?.get(key: MovieListSearchResultKey)
        applyMovieFilter(expression: searchText, on: results)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let results: MovieListSearchResultType? = appContext?.get(key: MovieListSearchResultKey)
        applyMovieFilter(expression: nil, on: results)
    }

}
