//
//  SearchCollectionViewCell.swift
//  Optima Coding Challenge
//
//  Created by Sukhpreet  Deol on 8/30/17.
//  Copyright © 2017 Sukhpreet  Deol. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet var playerView: YTPlayerView!
    
    func setVideo(result: GTLRYouTube_SearchResult) {
        playerView.load(withVideoId: result.identifier?.videoId ?? "")
        playerView.webView?.allowsInlineMediaPlayback = false
        playerView.layer.shadowColor = UIColor.darkGray.cgColor
        playerView.layer.shadowOffset = CGSize.zero
        playerView.layer.shadowOpacity = 1
        playerView.layer.shadowRadius = 10
    }
    
}

