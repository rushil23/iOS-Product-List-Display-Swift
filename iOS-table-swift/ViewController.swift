//
//  ViewController.swift
//  iOS-table-swift
//
//  Created by Rushil on 1/17/19.
//  Copyright © 2019 Rushil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    //MARK: Attributes and Variable Initialization
    
    final let url = URL(string: "https://jsonplaceholder.typicode.com/albums/1/photos") //Why do we use final ? ? ?
    @IBOutlet var tableView: UITableView!
    var cells = [Cell]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        // Do any additional setup after loading the view, typically from a nib.
        print("First Message")
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
            print("downloaded json")
            do{
                // Decoding JSON data fetched from URL
                let decoder = JSONDecoder()
                self.cells = try decoder.decode([Cell].self, from: data)
        
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(self.cells[0].title)
            } catch {
                print("decoding error")
            }
        }.resume()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("at line 59")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ListItems else { return UITableViewCell() }
        cell.CellLabel.text = cells[indexPath.row].title
        cell.CellImage.image = nil
        
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

