//
//  RestaurantDetailController.swift
//  Restaurant
//
//  Created by rps on 15/06/22.
//

import Foundation
import UIKit
import MapKit

class RestaurantDetailController : ViewController{
    var selectedRestaurant : RestaurantModel?
    var date : Date = Date.now
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    var restaurantDataSource = RestaurantDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        title = selectedRestaurant?.Name
        restaurantImageView.image = UIImage(named: selectedRestaurant!.Name)
        addressLabel.text = selectedRestaurant!.Address
        priceLabel.text = "\(selectedRestaurant!.Price) For Two"
        hotelName.text = selectedRestaurant?.Name
        favImageView.image = selectedRestaurant!.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        let favTapGesture = UITapGestureRecognizer(target: self, action: #selector(favTapped(tapGestureRecognizer:)))
        favImageView.isUserInteractionEnabled = true
        favImageView.addGestureRecognizer(favTapGesture)
        
        bookButton.setTitle(selectedRestaurant!.isBooked ? "Cancel Booking" : "Book Restaurant", for: .normal)
        setMapLocation()
        datepicker.minimumDate = Date.now
        if let bookingDate = selectedRestaurant!.BookingDate {
            datepicker.date = bookingDate
        }
    }
    
    func setMapLocation(){
        let annotation = MKPointAnnotation()
        annotation.title = selectedRestaurant?.Name
        annotation.coordinate = CLLocationCoordinate2D(latitude: selectedRestaurant!.Latitude, longitude: selectedRestaurant!.Longitude)
        
        mapview.addAnnotation(annotation)
        mapview.showAnnotations(mapview.annotations, animated: true)
    }
    
    @objc func favTapped(tapGestureRecognizer: UITapGestureRecognizer){
        restaurantDataSource.MarkRestaurantFavourite(name: selectedRestaurant!.Name, isFavourite: !selectedRestaurant!.isFavourite)
        selectedRestaurant!.isFavourite = !selectedRestaurant!.isFavourite
        
        DispatchQueue.main.async {
            self.favImageView.image = self.selectedRestaurant!.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            
            if (self.selectedRestaurant!.isFavourite){
                self.showToast(message: "Restaurant Added to favourites", seconds: 1.0)
            }
        }
    }
    
    @IBAction func bookRestaurant(_ sender: Any) {
        restaurantDataSource.BookRestaurant(name: selectedRestaurant!.Name, isBooked: !selectedRestaurant!.isBooked,bookingDate: date)
        selectedRestaurant!.isBooked = !selectedRestaurant!.isBooked
        
        let alert = UIAlertController(title: "Done", message: selectedRestaurant!.isBooked ? "Restaurant booking confirmed" : "Restaurant Booking cancelled", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
        
        DispatchQueue.main.async {
            self.bookButton.setTitle(self.selectedRestaurant!.isBooked ? "Cancel Booking" : "Book Restaurant", for: .normal)
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        date = sender.date
        if(date < Date.now){
            showToast(message: "Invalid date please select valid date", seconds: 1.0)
        }
    }
    
    func showToast(message : String, seconds: Double){
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
            }
     }
}
