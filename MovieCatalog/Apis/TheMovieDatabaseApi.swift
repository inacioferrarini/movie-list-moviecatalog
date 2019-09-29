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

///
/// Handles response from Movie API
///
protocol FetchMoviesDelegate: AnyObject {

    ///
    /// Handles popular movies response from API
    ///
    /// - Parameters:
    ///   - searchResult: Returned movies from the API
    ///   - request: The request identifier
    ///
    func handleFetchMovieSuccess(searchResult: MovieSearchResult?, for request: TheMovieDatabaseApi.Request)

    ///
    /// Handles popular movies error from API
    ///
    /// - Parameters:
    ///   - error: Returned error
    ///   - request: The request identifier
    ///
    func handleFetchMovieError(error: Error, for request: TheMovieDatabaseApi.Request)

}

///
/// Handles response from Genre API
///
protocol FetchGenresDelegate: AnyObject {

    ///
    /// Handles genres response from API
    ///
    /// - Parameters:
    ///   - searchResult: Returned genres from the API
    ///   - request: The request identifier
    ///
    func handleFetchGenresSuccess(genres: GenreListResult?, for request: TheMovieDatabaseApi.Request)

    ///
    /// Handles movie genres error from API
    ///
    /// - Parameters:
    ///   - error: Returned error
    ///   - request: The request identifier
    ///
    func handleFetchGenresError(error: Error, for request: TheMovieDatabaseApi.Request)

}

///
/// API for the Movie Database
///
struct TheMovieDatabaseApi {

    ///
    /// Available requests
    ///
    /// - popularMovies: Request for popular movies
    /// - genreList: Request for movie genres
    ///
    enum Request {
        ///
        /// Request for popular movies
        ///
        case popularMovies

        ///
        /// Request for movie genres
        ///
        case genreList
    }

    struct Movies {

        ///
        /// Returns the popular Movies
        ///
        /// - Parameter delegate: Delegate to handle API response
        ///
        func fetchPopularMovies(delegate: FetchMoviesDelegate, page: Int = 1) {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?page=1&api_key=389b2710a34413b185b37464a7cc60ce&page=\(page)") else {
                let error = NSError(domain: "", code: 404, userInfo: nil)
                delegate.handleFetchMovieError(error: error, for: .popularMovies)
                return
            }

            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"

            let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        delegate.handleFetchMovieError(error: error, for: .popularMovies)
                    }
                } else {
                    var searchResult: MovieSearchResult?
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        searchResult = try? decoder.decode(MovieSearchResult.self, from: data)
                    }
                    DispatchQueue.main.async {
                        delegate.handleFetchMovieSuccess(searchResult: searchResult, for: .popularMovies)
                    }
                }
            })
            dataTask.resume()
        }

        ///
        /// Returns the Movie genres
        ///
        /// - Parameter delegate: Delegate to handle API response
        ///
        func fetchGenres(delegate: FetchGenresDelegate) {
            guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=389b2710a34413b185b37464a7cc60ce") else {
                let error = NSError(domain: "", code: 404, userInfo: nil)
                delegate.handleFetchGenresError(error: error, for: .genreList)
                return
            }

            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"

            let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        delegate.handleFetchGenresError(error: error, for: .genreList)
                    }
                } else {
                    var genreResult: GenreListResult?
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        genreResult = try? decoder.decode(GenreListResult.self, from: data)
                    }
                    DispatchQueue.main.async {
                        delegate.handleFetchGenresSuccess(genres: genreResult, for: .genreList)
                    }
                }
            })
            dataTask.resume()
        }
    }

}
