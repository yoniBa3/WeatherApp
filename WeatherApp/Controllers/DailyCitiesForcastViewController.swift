//
//  DailyCitiesForcastViewController.swift
//  WeatherApp
//
//  Created by Yoni on 13/06/2020.
//  Copyright © 2020 Yoni. All rights reserved.
//

import UIKit

class DailyCitiesForcastViewController: UIViewController {

    //MARK: -Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviBar: UINavigationItem!
    
    
    //MARK: -UIActivityIndicator
    private var activityIndicator = UIActivityIndicatorView()
    
    //MARK: -Properties
    private var AllCities = [City]()
    private var filterdCities = [City](){
        didSet{
            tableView.reloadData()
        }
    }
    private var cities = [City](){
        didSet{
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.filterdCities = self.cities
            }
        }
    }
    private var degriesScale:DegriesScale = .Celsius{
        didSet{
            tableView.reloadData()
        }
    }
    
    //MARK: -LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configurePage()
        
        
        
    }


    //MARK: Functions
    
    private func configurePage(){
        configureTable()
        addSwitchBarToTheRight()
        
        DispatchQueue.main.async {
            self.readLocalJson()
        }
        
        activityIndicator.setup(with: view)
    }
    
    private func configureTable() {
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 15
        tableView.separatorInset.right = 15
        tableView.separatorColor = #colorLiteral(red: 0.900896132, green: 0.3806192279, blue: 0.9091120362, alpha: 1)
        
    }
    
    private func addSwitchBarToTheRight(){
        let switchBar = UISwitch()
        switchBar.addTarget(self, action: #selector(check), for: .touchUpInside)
        let switchDisplay = UIBarButtonItem(customView: switchBar)
        naviBar.rightBarButtonItem = switchDisplay
    }
    
    private func readLocalJson(){
        if let path = Bundle.main.url(forResource: "city.list", withExtension: ".json"){
        do{
            let urlFile = try Data(contentsOf: path, options: .mappedIfSafe)
            AllCities = try JSONDecoder().decode([City].self, from: urlFile)
            self.parseCitiesJson()
            
        }catch{
            print(error)
        }
    }
    }
    
    private func parseCitiesJson(){
        let increment = 20
        let maximumCities = 10_000
        
        for startIndex in stride(from: 0, to: maximumCities, by: increment){
            var array = [Int]()
            let incremented = startIndex + increment
            let endOfRange = incremented > maximumCities ? maximumCities : incremented
            for index in startIndex ..< endOfRange{
                array.append(AllCities[index].id)
            }
            JsonParser.shared.fecthWeather(with: array, request: .current) { (cities:GroupOfCities) in
                self.cities += cities.cities
            }
        }
        
    }
    
    //MARK: -Objc Functions
    @objc private func check(){
        if degriesScale == DegriesScale.Celsius {
            degriesScale = .Fahrenhite
        }else{
            degriesScale = .Celsius
        }
        title = "Change to \(degriesScale.rawValue)"
    }
}

//MARK: -Extensions

//MARK: -TableView
extension DailyCitiesForcastViewController:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DailyCityForCastTableViewCell.identifier, for: indexPath) as? DailyCityForCastTableViewCell{
            cell.degrieScale = degriesScale
            cell.configeCell(with: filterdCities[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdCities.count
    }
    
}

//MARK: -SearchBar
extension DailyCitiesForcastViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text{
            if !text.isEmpty{
                filterdCities = cities.filter({ (city) -> Bool in
                    city.name.lowercased().contains(text.lowercased())
                })
            }else{
                filterdCities = cities
            }
        }
    }
}


