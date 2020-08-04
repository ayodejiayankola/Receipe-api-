//
//  ViewController.swift
//  ReceipeData
//
//  Created by Ayodeji Ayankola on 8/1/20.
//  Copyright © 2020 konga.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var myTableView: UITableView?
    
       var receipe: [[String: Any]]?
//
//      let animal = ["dog" , "cat" , "pig"]
   override func viewDidLoad() {
     super.viewDidLoad()
    self.myTableView?.delegate = self
    self.myTableView?.dataSource = self
    self.downloadJson {
        DispatchQueue.main.async {
            self.myTableView?.reloadData()
        }
        
    }

         
     }
  

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.receipe?.count else { return 1 }
        print("count is \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
                cell.textLabel?.text = self.receipe?[indexPath.row]["name"] as? String
        var ingredName =  self.receipe?[indexPath.row]["name"] as? String
        print(self.receipe?[indexPath.row]["name"])
        
                return cell
    }
    
    
    func downloadJson(completed: @escaping () -> ()){
          let url = URL(string: "https://api.spoonacular.com/recipes/716429/information?apiKey=f85f1f3bd84342349fb589e4b6eaa5a7&includeNutrition=false")
          URLSession.shared.dataTask(with:url!){ (data, response, error ) in
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                let extendedIngredients = jsonData as? [String: Any]
                let dataArray = extendedIngredients!["extendedIngredients"] as? [[String : Any]]
                self.receipe = dataArray
//                print(self.receipe)
                completed()
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
          }.resume()
        }
    }

