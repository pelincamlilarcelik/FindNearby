//
//  ViewController.swift
//  FindNearby
//
//  Created by Onur Celik on 13.03.2023.
//

import UIKit
import MapKit
class ViewController: UIViewController {
    var locationManager: CLLocationManager?
    private var places: [PlaceAnnotation] = []
    
    private var searchTextField : UITextField = {
       let searchText = UITextField()
        searchText.placeholder = "Search"
        searchText.translatesAutoresizingMaskIntoConstraints = false
        searchText.layer.cornerRadius = 10
        searchText.clipsToBounds = true
        searchText.backgroundColor = .systemBackground
        searchText.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchText.leftViewMode = .always
        searchText.returnKeyType = .go
        
        return searchText
    }()
    
    lazy var map: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addConstraints()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
    }

    private func setUpUI(){
        view.addSubviews(map,searchTextField)
        
        
        
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            map.widthAnchor.constraint(equalTo: view.widthAnchor),
            map.heightAnchor.constraint(equalTo: view.heightAnchor),
            map.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            map.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            searchTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            searchTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            searchTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    private func checkLocationAuthorization(){
        if let locationManager = locationManager,
           let location = locationManager.location{
            switch locationManager.authorizationStatus{
                
            case .notDetermined,.restricted:
              print("Location can not be determined or restricted")
            case .denied:
              print("Location services has been denied")
            case .authorizedAlways,.authorizedWhenInUse:
                let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                map.setRegion(region, animated: true)
             @unknown default:
                print("Unknown error. Unable to get location")
            }
        }
        
    }
    private func presentPlacesSheet(places:[PlaceAnnotation]){
        guard let location = locationManager?.location else {return}
        let placesTVC = PlacesTableViewController(userLocation:location , places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        if let sheetVC = placesTVC.sheetPresentationController{
            sheetVC.detents = [.medium(),.large()]
            sheetVC.prefersGrabberVisible = true
            
        }
        present(placesTVC, animated: true)
    }
    private func findNearbyPlaces(query:String){
        // clear all annotations
        map.removeAnnotations(map.annotations)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = map.region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {return}
            
                self.places = response.mapItems.map(PlaceAnnotation.init)
                self.places.forEach { place in
                    self.map.addAnnotation(place)
                }
            
            
            self.presentPlacesSheet(places: self.places)
        }
        
    }
}
extension ViewController: MKMapViewDelegate{
    private func clearAllSelections(){
        self.places = self.places.map({ place in
            place.isSelected = false
            return place
        })
    }
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        clearAllSelections()
        guard let selectedAnnotation = annotation as? PlaceAnnotation else {return}
        let placeAnnotation = places.first(where: {$0.id == selectedAnnotation.id})
        placeAnnotation?.isSelected = true
        presentPlacesSheet(places: places)
        
        }
    
    
   
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty{
            textField.resignFirstResponder()
            textField.text = ""
            //search nearby locations
            findNearbyPlaces(query: text)
        }
        
        return true
    }
}
