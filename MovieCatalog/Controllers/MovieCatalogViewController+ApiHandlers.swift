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

extension MovieCatalogViewController {

    func mergeResults(searchResult: MovieSearchResult?, in previousSearchResult: MovieSearchResult?) -> MovieSearchResult? {
        guard let previousSearchResult = previousSearchResult else { return searchResult }
        guard let searchResult = searchResult else { return previousSearchResult }
        return searchResult + previousSearchResult
    }

    func updateFavorites(searchResult: MovieSearchResult?) -> MovieSearchResult? {
        guard let favorites = appContext?.favorites else { return searchResult }
        let favoriteIds = favorites.compactMap({ return $0.id })
        var updatedSearchResult = searchResult
        updatedSearchResult?.updateFavorites(favoriteIds: favoriteIds)
        return updatedSearchResult
    }

    // MARK: - Handles Popular Movies API response

    func handlePopularMoviesResponse(_ searchResult: MovieSearchResult?) {
        let previousSearchResult = appContext?.movieList
        let mergedSearchResult = mergeResults(searchResult: searchResult, in: previousSearchResult)
        let updatedSearchResult = updateFavorites(searchResult: mergedSearchResult)
        appContext?.movieList = updatedSearchResult
        movieCatalogView.movieSearchResult = updatedSearchResult
        dispatchGroup.leave()
    }

    func handlePopularMoviesResponse(_ error: Error) {
        self.movieCatalogView.showMessage(fetchPopularMoviesErrorMessage, kind: .error, direction: .top)
        dispatchGroup.leave()
    }

    // MARK: - Handles Genres API response

    func handleMovieGenresResponse(_ genres: GenreListResult?) {
        appContext?.genreList = genres
        dispatchGroup.leave()
    }

    func handleMovieGenresResponse(_ error: Error) {
        self.movieCatalogView.showMessage(fetchGenresErrorMessage, kind: .error, direction: .top)
        dispatchGroup.leave()
    }

}
