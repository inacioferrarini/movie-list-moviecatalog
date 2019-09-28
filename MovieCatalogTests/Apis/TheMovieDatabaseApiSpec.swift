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

//import Foundation
//import Quick
//import Nimble
//import OHHTTPStubs
//@testable import MovieCatalog
//
//class TheMovieDatabaseApiSpec: QuickSpec {
//    
//    override func spec() {
//        
//        describe("TheMovieDatabaseApi") {
//            
//            var delegate: FetchMoviesDelegateTest?
//            let api = TheMovieDatabaseApi.Movies()
//            
//            beforeEach {
//                delegate = FetchMoviesDelegateTest()
//            }
//
//            describe("Success case") {
//            
//                beforeEach {
//                    stub(condition: isHost("api.themoviedb.org")) { _ in
//                        let stubPath = OHPathForFile("MostPopularMoviesResponseData.json", type(of: self))
//                        return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
//                    }
//                }
//
//                afterEach {
//                    OHHTTPStubs.removeAllStubs()
//                }
//                
//                it("fetchPopularMovies must bring results") {
//                    api.fetchPopularMovies(delegate: delegate!)
//                    expect(delegate?.error).toEventually(beNil())
//                    expect(delegate?.searchResult).toNotEventually(beNil())
//                    expect(delegate?.request).toEventually(equal(TheMovieDatabaseApi.Request.popularMovies))
//                }
//
//            }
//            
//            describe("Failure case") {
//
//                beforeEach {
//                    stub(condition: isHost("api.themoviedb.org")) { _ in
//                        let notConnectedError = NSError(domain: NSURLErrorDomain,
//                                                        code: Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue),
//                                                        userInfo: nil)
//                        return OHHTTPStubsResponse(error: notConnectedError)
//                    }
//
//                }
//
//                afterEach {
//                    OHHTTPStubs.removeAllStubs()
//                }
//
//                it("fetchPopularMovies must handle errors") {
//                    api.fetchPopularMovies(delegate: delegate!)
//                    expect(delegate?.error).toNotEventually(beNil())
//                    expect(delegate?.searchResult).toEventually(beNil())
//                    expect(delegate?.request).toEventually(equal(TheMovieDatabaseApi.Request.popularMovies))
//                }
//                
//            }
//            
//        }
//        
//    }
//    
//}
