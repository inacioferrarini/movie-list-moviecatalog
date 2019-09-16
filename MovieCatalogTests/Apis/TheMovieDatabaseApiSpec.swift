import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import MovieCatalog

class TheMovieDatabaseApiSpec: QuickSpec {
    
    override func spec() {
        
        describe("TheMovieDatabaseApi") {
            
            var delegate: FetchMoviesDelegateTest?
            let api = TheMovieDatabaseApi.Movies()
            
            beforeEach {
                delegate = FetchMoviesDelegateTest()
            }

            describe("Success case") {
            
                beforeEach {
                    stub(condition: isHost("api.themoviedb.org")) { _ in
                        let stubPath = OHPathForFile("MostPopularMoviesResponseData.json", type(of: self))
                        return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
                    }
                }
                
                it("fetchPopularMovies must bring results") {
                    api.fetchPopularMovies(delegate: delegate!)
                    expect(delegate?.error).toEventually(beNil())
                    expect(delegate?.searchResult).toNotEventually(beNil())
                    expect(delegate?.request).toEventually(equal(TheMovieDatabaseApi.Request.popularMovies))
                }
                
            }
            
            describe("Failure case") {

                beforeEach {
                    stub(condition: isHost("api.themoviedb.org")) { _ in
                        let notConnectedError = NSError(domain: NSURLErrorDomain,
                                                        code: Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue),
                                                        userInfo: nil)
                        return OHHTTPStubsResponse(error: notConnectedError)
                    }

                }

                it("fetchPopularMovies must handle errors") {
                    api.fetchPopularMovies(delegate: delegate!)
                    expect(delegate?.error).toNotEventually(beNil())
                    expect(delegate?.searchResult).toEventually(beNil())
                    expect(delegate?.request).toEventually(equal(TheMovieDatabaseApi.Request.popularMovies))
                }
                
            }
            
        }
        
    }
    
}
