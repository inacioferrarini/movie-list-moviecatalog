import Foundation

/// Handles response from Movie API
protocol FetchMoviesDelegate: AnyObject {
    
    /// Handles popular movies response from API
    ///
    /// - Parameters:
    ///   - searchResult: Returned movies from the API
    ///   - request: The request identifier
    func handleSuccess(searchResult: SearchResult?, for request: TheMovieDatabaseApi.Request)
    
    /// Handles popular movies error from API
    ///
    /// - Parameters:
    ///   - error: Returned error
    ///   - request: The request identifier
    func handleError(error: Error, for request: TheMovieDatabaseApi.Request)

}

/// API for the Movie Database
struct TheMovieDatabaseApi {

    /// Available requests
    ///
    /// - popularMovies: Request for popular movies
    enum Request {
        /// Request for popular movies
        case popularMovies
    }
    
    struct Movies {
        
        /// Returns the popular Movies
        ///
        /// - Parameter delegate: Delegate to handle API response
        func fetchPopularMovies(delegate: FetchMoviesDelegate) {
            
            let postData = "{}".data(using: .utf8)
            var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/popular?page=1&api_key=389b2710a34413b185b37464a7cc60ce")!,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.httpBody = postData

            let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    delegate.handleError(error: error, for: .popularMovies)
                } else {
                    var searchResult: SearchResult?
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        searchResult = try? decoder.decode(SearchResult.self, from: data)
                    }
                    delegate.handleSuccess(searchResult: searchResult, for: .popularMovies)
                }
            })
            dataTask.resume()
        }
        
    }

}
