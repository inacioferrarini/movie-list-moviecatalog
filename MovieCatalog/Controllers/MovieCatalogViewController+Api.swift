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

import Foundation
import Common

extension MovieCatalogViewController {

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
    
    func popularMoviesResponse(_ searchResult: MovieSearchResult?) {
        let previousSearchResult: MovieSearchResult? = appContext?.get(key: MovieListSearchResultKey)
        let mergedSearchResult = mergeResults(searchResult: searchResult, in: previousSearchResult)
        let updatedSearchResult = updateFavorites(searchResult: mergedSearchResult)
        appContext?.set(value: updatedSearchResult as Any, for: MovieListSearchResultKey)
        movieCatalogView.movieSearchResult = updatedSearchResult
        dispatchGroup.leave()
    }

    func popularMoviesResponse(_ error: Error) {
        toast(withErrorMessage: fetchPopularMoviesErrorMessage)
        dispatchGroup.leave()
    }

}
