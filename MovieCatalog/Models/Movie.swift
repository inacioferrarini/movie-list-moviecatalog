import Foundation

struct Movie: Codable, Equatable {
    
    var title: String?
    var overview: String?
    var posterPath: String?
    var genreIds: [Int]?
    var releaseDate: String?
    
}
