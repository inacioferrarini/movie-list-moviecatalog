//    The MIT License (MIT)
//
//    Copyright (c) 2017 Inácio Ferrarini
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

import Common
import Flow

protocol MovieDetailsViewControllerDelegate: AnyObject {

}

class MovieDetailsViewController: UIViewController {


    // MARK: - Outlets

    @IBOutlet weak private(set) var movieDetailsView: MovieDetailsView!


    // MARK: - Properties

    weak var delegate: MovieDetailsViewControllerDelegate?
    weak var appContext: AppContext?
    var movie: Movie?


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieDetailsView.movie = self.movie
    }

    private func setup() {
        self.title = viewControllerTitle
        self.movieDetailsView.delegate = self
    }

}

extension MovieDetailsViewController: Storyboarded {}

extension MovieDetailsViewController: Internationalizable {

    var viewControllerTitle: String {
        return string("title", languageCode: "en-US")
    }

}

extension MovieDetailsViewController: MovieDetailsViewDelegate {

    func movieDetailsView(_ moviewDetailsView: MovieDetailsView, favorite: Bool, for movie: Movie) {

        if let movieId = movie.id, var favoriteIds: [Int] = appContext?.get(key: "favoriteMovies") {
            if favoriteIds.contains(movieId) {
                favoriteIds = favoriteIds.filter({ return $0 != movieId })
            } else {
                favoriteIds.append(movieId)
            }
            appContext?.set(value: favoriteIds, for: "favoriteMovies")
        }
    }

}
