//
//  ViewController.swift
//  WeatherApp
//
//  Created by Анита Самчук on 28.11.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let text = searchBar.text?.replacingOccurrences(of: " ", with: "%20")
        let urlString = "http://api.weatherstack.com/current?access_key=bb94f8ded7c0c10a9529bf2dbb217fe1&query=\(text ?? " ")"
         
        guard let url = URL(string: urlString) else {return}
        
        var locationName: String?
        var currentTemperature: Int?
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            do{
                let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers) as? [String: AnyObject] ?? [String: AnyObject]()
                    
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
                
                if let current = json["current"] {
                    currentTemperature = current["temperature"] as? Int
                }
                
                DispatchQueue.main.async {
                    self?.cityLabel.text = locationName
                    self?.currentTemperatureLabel.text = "\(currentTemperature ?? 0)℃"
                }
        }
            catch let jsonError {
                print(jsonError)
            }

        }
        task.resume()
        
    }
}
