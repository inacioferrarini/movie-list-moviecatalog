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

import Common

protocol MovieCatalogViewControllerDelegate: AnyObject {

    func movieCatalogViewController(_ movieCatalogViewController: MovieCatalogViewController, didSelected movie: Movie)

}

class MovieCatalogViewController: UIViewController {


    // MARK: - Outlets

    @IBOutlet weak private(set) var movieCatalogView: MovieCatalogView!


    // MARK: - Properties

    weak var appContext: AppContext?
    weak var delegate: MovieCatalogViewControllerDelegate?


    // MARK: - Lifecycle

    let dispatchGroup = DispatchGroup()

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
            movieCatalogView.movieSearchResult = movieSearchResult
        }
    }

    private func setup() {
        self.title = viewControllerTitle
        self.movieCatalogView.delegate = self
    }

    private func fetchFavoriteMoviesData() {
        movieCatalogView.showLoadingView()
        let api = TheMovieDatabaseApi.Movies()
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            api.fetchPopularMovies(delegate: self)
        }
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            api.fetchGenres(delegate: self)
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { [unowned self] in
            self.movieCatalogView.hideLoadingView()
        }

    }

}

extension MovieCatalogViewController: Storyboarded {}

extension MovieCatalogViewController: Internationalizable {

    var viewControllerTitle: String {
        return string("title", languageCode: "en-US")
    }

}

extension MovieCatalogViewController: FetchMoviesDelegate {

    func mergeResults(searchResult: MovieSearchResult?, in previousSearchResult: MovieSearchResult?) -> MovieSearchResult? {
        guard let previousSearchResult = previousSearchResult else { return searchResult }
        guard var searchResult = searchResult else { return previousSearchResult }
        var results = previousSearchResult.results
        let newResults = searchResult.results
        results += newResults
        searchResult.results = results
        return searchResult
    }

    func updateFavorites(searchResult: MovieSearchResult?) -> MovieSearchResult? {
        guard var updatedSearchResult = searchResult else { return nil}
        guard let favoriteIds: [Int] = appContext?.get(key: "favoriteMovies") else { return searchResult }

        var updatedMovies: [Movie] = []
        for var movie in updatedSearchResult.results {
            movie.isFavorite = favoriteIds.contains(movie.id ?? -1)
            updatedMovies.append(movie)
        }
        updatedSearchResult.results = updatedMovies
        return updatedSearchResult
    }

    func handleFetchMovieSuccess(searchResult: MovieSearchResult?, for request: TheMovieDatabaseApi.Request) {
        let previousSearchResult: MovieSearchResult? = appContext?.get(key: MovieListSearchResultKey)
        let mergedSearchResult = mergeResults(searchResult: searchResult, in: previousSearchResult)
        let updatedSearchResult = updateFavorites(searchResult: mergedSearchResult)
        appContext?.set(value: updatedSearchResult as Any, for: MovieListSearchResultKey)
        movieCatalogView.movieSearchResult = updatedSearchResult
        dispatchGroup.leave()
    }

    func handleFetchMovieError(error: Error, for request: TheMovieDatabaseApi.Request) {
        print("... handleFetchMovieError")
        print("Request \(request), Error -> \(error)")
        dispatchGroup.leave()
    }

}

extension MovieCatalogViewController: FetchGenresDelegate {

    func handleFetchGenresSuccess(genres: GenreListResult?, for request: TheMovieDatabaseApi.Request) {
        appContext?.set(value: genres as Any, for: GenreListSearchResultKey)
        dispatchGroup.leave()
    }

    func handleFetchGenresError(error: Error, for request: TheMovieDatabaseApi.Request) {
        print("... handleFetchGenresError")
        print("Request \(request), Error -> \(error)")
        dispatchGroup.leave()
    }

}

extension MovieCatalogViewController: MovieCatalogViewDelegate {

    func moviewCatalogView(_ moviewCatalogView: MovieCatalogView, didSelected movie: Movie) {
        delegate?.movieCatalogViewController(self, didSelected: movie)
    }

    func moviewCatalogView(_ moviewCatalogView: MovieCatalogView, requestFavoritePage page: Int) {
        let api = TheMovieDatabaseApi.Movies()
        DispatchQueue.global().async { [unowned self] in
            self.dispatchGroup.enter()
            api.fetchPopularMovies(delegate: self, page: page)
         }
    }

}
