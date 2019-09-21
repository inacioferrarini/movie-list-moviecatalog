import Foundation

/// Handles response from Movie API
protocol FetchMoviesDelegate: AnyObject {
    
    /// Handles popular movies response from API
    ///
    /// - Parameters:
    ///   - searchResult: Returned movies from the API
    ///   - request: The request identifier
    func handleFetchMovieSuccess(searchResult: SearchResult?, for request: TheMovieDatabaseApi.Request)
    
    /// Handles popular movies error from API
    ///
    /// - Parameters:
    ///   - error: Returned error
    ///   - request: The request identifier
    func handleFetchMovieError(error: Error, for request: TheMovieDatabaseApi.Request)

}

/// Handles response from Genre API
protocol FetchGenresDelegate: AnyObject {
    
    /// Handles genres response from API
    ///
    /// - Parameters:
    ///   - searchResult: Returned genres from the API
    ///   - request: The request identifier
    func handleFetchGenresSuccess(genres: GenreListResult?, for request: TheMovieDatabaseApi.Request)
    
    /// Handles movie genres error from API
    ///
    /// - Parameters:
    ///   - error: Returned error
    ///   - request: The request identifier
    func handleFetchGenresError(error: Error, for request: TheMovieDatabaseApi.Request)

}

/// API for the Movie Database
struct TheMovieDatabaseApi {

    /// Available requests
    ///
    /// - popularMovies: Request for popular movies
    /// - genreList: Request for movie genres
    enum Request {
        /// Request for popular movies
        case popularMovies
        /// Request for movie genres
        case genreList
    }
    
    struct Movies {
        
        /// Returns the popular Movies
        ///
        /// - Parameter delegate: Delegate to handle API response
        func fetchPopularMovies(delegate: FetchMoviesDelegate) {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?page=1&api_key=389b2710a34413b185b37464a7cc60ce") else {
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
                    var searchResult: SearchResult?
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        searchResult = try? decoder.decode(SearchResult.self, from: data)
                    }
                    DispatchQueue.main.async {
                        delegate.handleFetchMovieSuccess(searchResult: searchResult, for: .popularMovies)
                    }
                }
            })
            dataTask.resume()
        }

        /// Returns the Movie genres
        ///
        /// - Parameter delegate: Delegate to handle API response
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
