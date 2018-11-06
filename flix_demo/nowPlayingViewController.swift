//
//  nowPlayingViewController.swift
//  flix_demo
//
//  Created by Tu Pham on 11/6/18.
//  Copyright © 2018 Van Lao. All rights reserved.
//

import UIKit
import AlamofireImage
class nowPlayingViewController: UIViewController, UITableViewDataSource {

    
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var movieList: [[String: Any]] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actIndicator.startAnimating()
        tableView.dataSource = self
        tableView.rowHeight = 210
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(nowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        // Do any additional setup after loading the view.
        fetchMovie()
        
    }
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        fetchMovie()
    }
    
    func fetchMovie(){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // TODO: Get the array of movies
                let movies = dataDictionary["results"] as! [[String: Any]]
                // TODO: Store the movies in a property to use elsewhere
                self.movieList = movies
                self.actIndicator.stopAnimating()
                // TODO: Reload your table view data
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
        task.resume()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return movieList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        let movie = movieList[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURL + posterPath)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterImage.af_setImage(withURL: posterURL!)
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
