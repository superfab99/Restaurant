//
//  RestaurantDataSource.swift
//  Restaurant
//
//  Created by rps on 17/06/22.
//

import Foundation
import UIKit
import CoreData
struct RestaurantDataSource{

    func seedRestaurants(){
        var restaurants : [RestaurantModel] = [RestaurantModel(isBooked: false,isFavourite: false, Name: "Oham Manis", Address: "Bantul, Yogyakarta", Price: "1700", Latitude: 1.3567254, Longitude: 103.863446, BookingDate: nil),RestaurantModel(isBooked: false,isFavourite: false, Name: "AppleBees", Address: "Sembalun, Lombok", Price: "1100", Latitude: 41.6639822, Longitude: -86.1391748, BookingDate: nil),RestaurantModel(isBooked: false,isFavourite: false, Name: "Cheesery", Address: "Batu, Malang", Price: "1000", Latitude: 36.1745125, Longitude: -115.1558371, BookingDate: nil),RestaurantModel(isBooked: false,isFavourite: false, Name: "Blue Sky", Address: "Mandalika, Kolhapur", Price: "1400", Latitude: 36.0397879, Longitude: -114.9818152, BookingDate: nil),RestaurantModel(isBooked: false,isFavourite: false, Name: "KokoroSushi", Address: "Bantul, Yogyakarta", Price: "2200", Latitude: 16.544869, Longitude: 73.615309, BookingDate: nil),RestaurantModel(isBooked: false,isFavourite: false, Name: "Melvyns", Address: "Sembalun, Lombok", Price: "1700", Latitude: 33.8088786, Longitude: -116.5430869,BookingDate: nil),RestaurantModel(isBooked: false,isFavourite: false, Name: "Rosemarys", Address: "Batu, Malang", Price: "1800", Latitude: 26.732186, Longitude: -80.0564202,BookingDate: nil),RestaurantModel(isBooked: false,isFavourite: false, Name: "East Coast Wings Grill", Address: "Mandalika, Kolhapur", Price: "2400", Latitude: 39.9939557, Longitude: -75.9404194,BookingDate: nil)]
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let restaurantEntity = NSEntityDescription.entity(forEntityName: "Restaurants", in: managedContext)
        
        for data in restaurants{
            let restaurant = NSManagedObject(entity: restaurantEntity!, insertInto: managedContext)
            restaurant.setValue(data.Name, forKey: "name")
            restaurant.setValue(data.Price, forKey: "price")
            restaurant.setValue(data.Address, forKey: "address")
            restaurant.setValue(data.Latitude, forKey: "latitude")
            restaurant.setValue(data.Longitude, forKey: "longitude")
            restaurant.setValue("22-536345", forKey: "phone")
            restaurant.setValue(data.isBooked, forKey: "isbooked")
            restaurant.setValue(data.isFavourite, forKey: "isfavourite")
        }
        
        do{
            try managedContext.save()
            print("Data seeded successfully")
        }catch let error as NSError{
            print("could not save \(error),\(error.userInfo)")
        }
    }
    
    func getAllRestaurants() -> [RestaurantModel]{
        var data = [RestaurantModel]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return data}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurants")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            for rest in result as! [NSManagedObject]{
                var restaurant = RestaurantModel(isBooked: rest.value(forKey: "isbooked") as! Bool,isFavourite: rest.value(forKey: "isfavourite") as! Bool,Name: rest.value(forKey: "name") as! String, Address: rest.value(forKey: "address") as! String, Price: rest.value(forKey: "price") as! String, Latitude: rest.value(forKey: "latitude") as! Double, Longitude: rest.value(forKey: "longitude") as! Double, BookingDate: rest.value(forKey: "date") as? Date)
                
                data.append(restaurant)
            }
        }
        catch{
            print("Error if data exists")
        }
        return data
    }
    
    
    func checkIfDataExists() -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurants")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            if(result.count > 0){
                return true
            }
        }
        catch{
            print("Error if data exists")
        }
        return false
    }
    
    func MarkRestaurantFavourite(name: String, isFavourite: Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurants")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let restaurantToUpdate = result[0] as! NSManagedObject
            restaurantToUpdate.setValue(isFavourite, forKey:"isfavourite")
            
            try managedContext.save()
            print("Restaurant updated sucessfully")
          }
        catch{
            print("Failed to mark restaurant as favourite")
        }
    }
    
    func BookRestaurant(name: String,isBooked: Bool,bookingDate: Date){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurants")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let restaurantToUpdate = result[0] as! NSManagedObject
            restaurantToUpdate.setValue(isBooked, forKey: "isbooked")
            restaurantToUpdate.setValue(isBooked ? bookingDate : nil, forKey: "date")
            try managedContext.save()
            print("Restaurant booked sucessfully")
          }
        catch{
            print("Failed to book restaurant")
        }
    }
}
