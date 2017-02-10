//
//  MovieDetailViewController.swift
//  Tumblr Feed
//
//  Created by Shayin Feng on 2/9/17.
//  Copyright © 2017 Shayin Feng. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    var post : NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0

        super.viewDidLoad()
        print(post)
        // Do any additional setup after loading the view.
         if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            if let imageUrlString = (photos[0].value(forKeyPath: "original_size.url") as? String) {
                if let imageUrl = URL(string: imageUrlString) {
                    movieImage.setImageWith(imageUrl)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
