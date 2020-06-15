//
//  WeeklyCityForcastViewController.swift
//  WeatherApp
//
//  Created by Yoni on 14/06/2020.
//  Copyright © 2020 Yoni. All rights reserved.
//

import UIKit

class WeeklyCityForcastViewController: UIViewController {
    
    //MARK: -Outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviBar: UINavigationItem!
    
    //MARK: -UIActivityIndicator
    private var activityIndicator = UIActivityIndicatorView()
    
    
    //MARK: -Properties
    public static let segueIdentifier = "WeeklyCityForcastSegue"
    private var days = [Day](){
        didSet{
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.swichBar.isEnabled = true
            }
        }
    }
    var id: Int?
    var cityName: String?
    var degriesScale:DegriesScale?
    private let swichBar = UISwitch()
    var swichBarDelegate: swichBarDelegte!
    //MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configurePage()
        
    }
    
    //MARK: Actions
    
    
    //MARK: Functions
    private func configurePage(){
        configureTable()
        cityNameLabel.text = cityName
        addSwitchBarToTheRight()
        activityIndicator.setup(with: view)
        DispatchQueue.main.async {
            self.parsWeeklyJson()
        }
    }
    
    private func configureTable() {
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.right = 15
        tableView.separatorInset.left = 15
        tableView.separatorColor = .blue
        
    }
    
    private func addSwitchBarToTheRight(){
        
        var isFahrenhite = false
        if degriesScale == DegriesScale.Fahrenhite{
            isFahrenhite = true
        }
        if let scale = degriesScale?.rawValue{
            title = "Change to \(scale)"
        }
        
        swichBar.isOn = isFahrenhite
        
        swichBar.addTarget(self, action: #selector(checkDegriesSacle), for: .touchUpInside)
        let swichDisplay = UIBarButtonItem(customView: swichBar)
        naviBar.rightBarButtonItem = swichDisplay
        swichBar.isEnabled = false
    }
    
    private func parsWeeklyJson(){
        JsonParser.shared.fecthWeather(with: [id!], request: .weekly) { (week:WeeklyCityForcast) in
            
            let increment = 8
            let maximumList = week.list.count
            
            for startRange in stride(from: 0, to: maximumList, by: increment){
                var minTempArray = [Int]()
                var maxTempArray = [Int]()
                let incremented = startRange + increment
                let endOfRange = incremented > maximumList ? maximumList : incremented
                for index in startRange ..< endOfRange{
                    if let minTemp = week.list[index].main?.tempMin.rounded(){
                        minTempArray.append(Int(minTemp))
                    }
                    if let maxTemp = week.list[index].main?.tempMax.rounded(){
                        maxTempArray.append(Int(maxTemp))
                    }
                }
                var day = Day()
                if let dateTxt = week.list[startRange].dt_txt{
                    day.dayName = self.getDayNameFromDate(dateInString: dateTxt)
                }
                day.minTemp = minTempArray.reduce( 0 , {$0 + $1}) / increment
                day.maxTemp = maxTempArray.reduce( 0 , {$0 + $1}) / increment
                if let weather = week.list[startRange].weather?[0]{
                    day.icon = weather.icon
                }
                print(day)
                self.days.append(day)
                
            }
        }
    }
    
    private func getDayNameFromDate(dateInString dateText:String) -> String{
        let dateFormaterGet = DateFormatter()
        dateFormaterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormaterSet = DateFormatter()
        dateFormaterSet.dateFormat = "EEEE"
        var dateReturend = ""
        if let date = dateFormaterGet.date(from: dateText){
            dateReturend = dateFormaterSet.string(from: date)
        }
        return dateReturend
    }
    
    //MARK: -Objc Functions
    @objc private func checkDegriesSacle(){
        if degriesScale != nil{
            
            if degriesScale == DegriesScale.Celsius {
                degriesScale = .Fahrenhite
            }else{
                degriesScale = .Celsius
            }
            
            title = "Change to \(degriesScale!.rawValue)"
            tableView.reloadData()
            self.swichBarDelegate.didCange(with: degriesScale!)
        }
    }
}

//MARK: -Extensions

//MARK: UITableView
extension WeeklyCityForcastViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WeeklyCityForcastTableViewCell.identifier, for: indexPath) as? WeeklyCityForcastTableViewCell{
            cell.degriesScale = degriesScale
            cell.configureCell(with: days[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension WeeklyCityForcastViewController: UITableViewDelegate{
    
}
