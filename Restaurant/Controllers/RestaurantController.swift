//
//  RestaurantController.swift
//  Restaurant
//
//  Created by rps on 14/06/22.
//

import Foundation
import UIKit
class RestaurantController : ViewController, UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    var datasource = RestaurantDataSource()
    var restaurants = [RestaurantModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        title = "Restaurants"
        tableview.dataSource = self
        tableview.delegate = self
        
        if(!datasource.checkIfDataExists()){
            datasource.seedRestaurants()
        }
        
        restaurants = datasource.getAllRestaurants()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        restaurants.removeAll()
        restaurants = datasource.getAllRestaurants()
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantcell",for: indexPath) as! RestaurantTableViewCell
        
        cell.restaurantName.text = restaurants[indexPath.row].Name
        cell.restaurantPrice.text = "INR: \(restaurants[indexPath.row].Price)"
        cell.restaurantType.text = "Restaurant"
        cell.restaurantImage.image = UIImage(named: restaurants[indexPath.row].Name)
        cell.restaurantFavImg.image = restaurants[indexPath.row].isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        cell.restaurantBookedButton.isHidden = !restaurants[indexPath.row].isBooked
        cell.restaurantAddress.text = restaurants[indexPath.row].Address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "restaurantdetailcontroller") as! RestaurantDetailController
        detailViewController.selectedRestaurant = restaurants[indexPath.row]
        self.navigationController?.pushViewController(detailViewController,animated: true)
    }
    
}
