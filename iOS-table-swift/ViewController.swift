//
//  ViewController.swift
//  iOS-table-swift
//
//  Created by Rushil on 1/17/19.
//  Copyright © 2019 Rushil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    //MARK: Attributes and Variable Initialization
    final let url = URL(string: "https://jsonplaceholder.typicode.com/albums/1/photos") 
    var cells = [Cell]()
    let rowHeight = 44 //Fixed Row Height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = rowHeight
        downloadJson() //Starts downloading JSON data as soon as view loads
    }
    
    // Function to download and decode the JSON information from URL
    func downloadJson(){
        guard let downloadURL = url else { return } //guard needed because URL link may fail / =nil
        
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse,error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Download Failed") // When error occurs while downloading JSON data
                return
            }
            print("Downloaded JSON Data")
            do{
                // Decoding JSON data fetched from URL
                let decoder = JSONDecoder()
                self.cells = try decoder.decode([Cell].self, from: data)
        
                DispatchQueue.main.async { // To update the view with the list of products
                    self.tableView.reloadData()
                }
                print(self.cells[0].title)
            } catch {
                print("Decoding error")
            }
        }.resume()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ListItems else { return UITableViewCell() }
        cell.CellLabel.text = cells[indexPath.row].title
        cell.CellImage.image = nil
        
        // Downloading product image for the cell
        if let imageURL = URL(string: cells[indexPath.row].thumbnailUrl) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.CellImage.image = image
                    }
                }
            }
        }
        return cell
    }
}

