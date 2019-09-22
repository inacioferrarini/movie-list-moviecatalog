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

class MovieCatalogCollectionViewDelegate<CellType: UICollectionViewCell, Type: Equatable>: PageLoaderCollectionViewDelegate<CellType, Type>,
    UICollectionViewDelegateFlowLayout
    where CellType: Configurable {

    ///
    /// The collection view
    ///
    let collectionView: UICollectionView


    // MARK: - Initialization

    ///
    /// Inits the Delegate.
    ///
    /// - parameter with: DataSource backing the CollectionView, where data will be extracted from.
    ///
    /// - parameter onSelected: Logic to handle value selection.
    ///
    /// - parameter shouldLoadNextPage: Validation logic for page loading.
    ///
    /// - parameter loadNextPage: Logic to load next page.
    ///
    public required init(with dataSource: CollectionViewArrayDataSource<CellType, Type>,
                         onSelected: @escaping ((Type) -> Void),
                         shouldLoadNextPage: @escaping (() -> Bool),
                         loadNextPage: @escaping (() -> Void),
                         for collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(with: dataSource, onSelected: onSelected, shouldLoadNextPage: shouldLoadNextPage, loadNextPage: loadNextPage)
    }

    required init(with dataSource: CollectionViewArrayDataSource<CellType, Type>,
                  onSelected: @escaping ((Type) -> Void),
                  shouldLoadNextPage: @escaping (() -> Bool),
                  loadNextPage: @escaping (() -> Void)) {
        fatalError("init(with:onSelected:shouldLoadNextPage:loadNextPage:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let margin = CGFloat(30)
        let width = (self.collectionView.bounds.width - margin) / 2
        let height = width * 1.25
        return CGSize(width: width, height: height)
    }

}
