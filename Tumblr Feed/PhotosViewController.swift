//
//  PhotosViewController.swift
//  Tumblr Feed
//
//  Created by Shayin Feng on 2/1/17.
//  Copyright © 2017 Shayin Feng. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // This is where you can get into trouble ivarosts contains nil which is why we initialized posts as an empty array because although empty, it is not nil.
    var posts: [NSDictionary] = []
    
    @IBOutlet weak var photoTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var isMoreDataLoading = false
    
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        photoTableView.rowHeight = 240;
        
        refreshControl.addTarget(self, action: #selector(PhotosViewController.refresh(sender: )), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        photoTableView.insertSubview(refreshControl, at: 0)
    
        request()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell") as! PhotoCell
        
        let post = posts[indexPath.row]
        
        // let timestamp = post["timestamp"] as? String
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = URL(string: imageUrlString!) {
                cell.postImage.setImageWith(imageUrl)
            }
            
            let trail = post["trail"] as! NSArray
            let traildAtZero = trail[0] as! NSDictionary
            let blog = traildAtZero["blog"] as! NSDictionary
            //            let theme = blog["theme"] as! NSDictionary
            //let headUrlString =  theme["header_image"]
            
            
            cell.username.text = blog["name"] as? String
            
            let headUrlString = "https://api.tumblr.com/v2/blog/\(cell.username.text!).tumblr.com/avatar"
            
            if let headUrl = URL(string: headUrlString) {
                cell.userhead.setImageWith(headUrl)
            }
            
        } else {
            cell.textLabel?.text = "This is row \(indexPath.row)"
        }
        
        
        return cell
    }
    
    func loadMoreData() {
        
        // ... Create the NSURLRequest (myRequest) ...

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = photoTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - photoTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && photoTableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                offset += 1
                request()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showMovieDetail") {
            let vc = segue.destination as! MovieDetailViewController
            
            if let cell = sender as? UITableViewCell {
                if let indexPath = photoTableView.indexPath(for: cell) {
                    var post : NSDictionary!
                    post = posts[indexPath.row]
                    vc.post = post
                }
            }
        }
    }
    
    func request () {
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(offset * self.posts.count)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts += responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        self.photoTableView.reloadData()
                        // print(self.posts)
                        
                        self.refreshControl.endRefreshing()
                        
                        self.isMoreDataLoading = false
                    }
                }
        });
        task.resume()
    }
    
    func refresh (sender : UIRefreshControl) {
        request()
    }
}



