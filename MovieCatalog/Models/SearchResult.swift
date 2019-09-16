import Foundation

struct SearchResult: Codable {
    
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var results: [Movie]
    
}
