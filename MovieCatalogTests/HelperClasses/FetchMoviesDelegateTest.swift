import Common
@testable import MovieCatalog

class FetchMoviesDelegateTest: FetchMoviesDelegate {

    var error: Error?
    var searchResult: SearchResult?
    var request: TheMovieDatabaseApi.Request?

    func handleSuccess(searchResult: SearchResult?, for request: TheMovieDatabaseApi.Request) {
        self.error = nil
        self.searchResult = searchResult
        self.request = request
    }

    func handleError(error: Error, for request: TheMovieDatabaseApi.Request) {
        self.error = error
        self.searchResult = nil
        self.request = request
    }

}
