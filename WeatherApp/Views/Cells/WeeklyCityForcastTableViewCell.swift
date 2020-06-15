//
//  WeeklyCityForcastTableViewCell.swift
//  WeatherApp
//
//  Created by Yoni on 14/06/2020.
//  Copyright © 2020 Yoni. All rights reserved.
//

import UIKit

class WeeklyCityForcastTableViewCell: UITableViewCell {
    
    //MARK: -Outlets
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var avregeTempLabel: UILabel!
    
    
    //MARK: -Properties
    public static let identifier = "WeeklyCityForcastCell"
    var degriesScale:DegriesScale!
    
    //MARK: -LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with day :Day){
        weatherImageView.image = UIImage(named: day.icon)
        dayLabel.text = day.dayName
        
        var minTemp = day.minTemp
        var maxTemp = day.maxTemp
        var degrieSign = "℃"
        
        if degriesScale == DegriesScale.Fahrenhite{
            minTemp = minTemp * (9/5) + 32
            maxTemp = maxTemp * (9/5) + 32
            degrieSign = "℉"
        }
        
        avregeTempLabel.text = "\(Int(minTemp)) - \(Int(maxTemp))" + degrieSign
    }

}
