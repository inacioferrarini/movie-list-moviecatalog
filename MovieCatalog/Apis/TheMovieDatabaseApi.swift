import Foundation

/// Handles response from Movie API
protocol FetchMoviesDelegate: AnyObject {
    
    func handleSuccess(searchResult: SearchResult?, for request: TheMovieDatabaseApi.Request)
    func handleError(error: Error, for request: TheMovieDatabaseApi.Request)

}

struct TheMovieDatabaseApi {

    enum Request {
        case popularMovies
    }
    
    struct Movies {
        
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
