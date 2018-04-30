//
//  SearchCollectionViewController.swift
//  Optima Coding Challenge
//
//  Created by Sukhpreet  Deol on 8/30/17.
//  Copyright © 2017 Sukhpreet  Deol. All rights reserved.
//

import UIKit

class SearchCollectionViewController: UICollectionViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    // Search Cell Identifier for reuse cell
    let reuseIdentifier = "SearchCell"
    
    // Number of items/viedos per page
    let numberOfItemsPerPage = UInt(30)
    
    // If there is more itmes/videos then response will set next page token
    var nextPageToken: String? = nil
    
    // user's keyword which in UISearchBar
    var keyword: String = ""
    
    // service must be set from Google SignInViewController because its require authorization
    var service: GTLRYouTubeService! = nil
    
    // result items come from user search
    var results: [GTLRYouTube_SearchResult] = []
    
    // cell size which will be determine by diffrent screen size and oreintation
    // please see setCellSize(approxCellWidth: ...) and setCellSize(numberOfCellsInRow: ...)
    var cellSize = CGSize(width: 300, height: 300)
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        
        // Uncomment the following line to hide navigation bar on swipe or tap
        // self.navigationController?.hidesBarsOnTap = true
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchVideos()
        self.setCellSize(approxCellWidth: 300, withRatioHeight: 1.0)
        self.collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Update cell size with respect to new size and reload layout
        self.setCellSize(approxCellWidth: 300, withRatioHeight: 1.0, viewWidth: size.width)
        self.collectionViewLayout.invalidateLayout()
    }
    
    
    // MARK: - Helper Methods
    
    /// Set cell size, the height of cell will be ratio or multiplier of width. But width
    /// will be determined by the approximate width. So if approximate width is 100pt and
    /// - If screen width is 320pt then 320/100 = 3 which will be consider as number of columns
    /// - If screen width is 414pt then 414/100 = 4 which will be consider as number of columns
    open func setCellSize(approxCellWidth: CGFloat, withRatioHeight ratio: CGFloat, viewWidth: CGFloat? = nil) {
        let viewWidth = viewWidth ?? collectionView!.bounds.width
        let numberOfCellsInRow = CGFloat(Int(viewWidth / approxCellWidth))
        setCellSize(numberOfCellsInRow: numberOfCellsInRow, withRatioHeight: ratio, viewWidth: viewWidth)
    }
    
    /// Set cell size, the height of cell will be ratio or multiplier of width. But width
    /// will be determined by the number of columns and section Inset. So iPhone5 screen will
    /// be different width as compare to iPhone6+
    func setCellSize(numberOfCellsInRow: CGFloat, withRatioHeight ratio: CGFloat, viewWidth: CGFloat? = nil) {
        var numberOfCellsInRow = numberOfCellsInRow
        if numberOfCellsInRow < 1 {
            numberOfCellsInRow = 1
        }
        
        let sectionInset = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? UIEdgeInsets()
        let viewWidth = viewWidth ?? collectionView!.bounds.width
        let cellWidth = (viewWidth - sectionInset.left*CGFloat(numberOfCellsInRow+1)) / numberOfCellsInRow
        let cellHeight = cellWidth * ratio
        self.cellSize = CGSize(width: cellWidth, height: cellHeight)
    }
    
    /// search videos by keyword given in search bar. If nextPageToken exists then fetch from after that
    @objc func searchVideos() {
        let newKeyword = searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        if keyword != newKeyword {
            keyword = newKeyword
            nextPageToken = nil
        }
        
        let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
        query.q = keyword
        query.pageToken = nextPageToken
        query.maxResults = numberOfItemsPerPage
        query.type = ""
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    /// Process the response and display output.
    /// If there is no previous next page token then it will be consiter first page and reload data of collection view
    /// Otherwise new items will be append in results array and insert in collection view
    @objc func displayResultWithTicket( ticket: GTLRServiceTicket, finishedWithObject response : GTLRYouTube_SearchListResponse, error : NSError?) {
        
        if let error = error {
            UIAlertController.present(on: self, "Error", message: error.localizedDescription)
            return
        }
        
        if nextPageToken == nil {
            self.nextPageToken = response.nextPageToken
            self.results = response.items ?? []
            self.collectionView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 10, height: 10) , animated: false)
            self.collectionView?.reloadData()
        } else {
            self.nextPageToken = response.nextPageToken
            
            // create indexPaths array for new items
            var indexPaths: [IndexPath] = []
            let count = response.items?.count ?? 0
            for i in 0 ..< count {
                indexPaths.append(IndexPath(row: i+self.results.count, section: 0))
            }
            
            // appending and inserting
            self.results.append(contentsOf: response.items ?? [])
            self.collectionView?.performBatchUpdates({
                self.collectionView?.insertItems(at: indexPaths)
            }, completion: { (finished) in
                // no-op
            })
        }
        
    }
    
    // MARK: - Override UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCollectionViewCell
        cell.setVideo(result: results[indexPath.row])
        
        // if index path is last cell and there is next page toaken then
        // search video with next toke
        if indexPath.row == results.count-1 && nextPageToken != nil {
            searchVideos()
        }
        
        return cell
    }
    
    
    // MARK: - Override UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     
     override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
     guard let cell = collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell else { return }
     UIView.animate(withDuration: 0.3) {
     cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
     }
     }
     
     override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
     guard let cell = collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell else { return }
     UIView.animate(withDuration: 0.3) {
     cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
     }
     }
     */
    
}


// MARK: - UICollectionViewFlowLayout Delegate
extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
}


// MARK: - UISearchBar Delegate
extension SearchCollectionViewController: UISearchBarDelegate {
    
    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        nextPageToken = nil
        searchVideos()
        searchBar.resignFirstResponder()
    }
    
    // called when text changes (including clear)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchVideos), object: nil)
        self.perform(#selector(searchVideos), with: nil, afterDelay: 1.0)
    }
}

