//
//  DailyCityForCastTableViewCell.swift
//  WeatherApp
//
//  Created by Yoni on 13/06/2020.
//  Copyright © 2020 Yoni. All rights reserved.
//

import UIKit

class DailyCityForCastTableViewCell: UITableViewCell {
    //MARK: -Outlets
    @IBOutlet weak var descriptionImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minMaxTempLabel: UILabel!
    //MARK: -Properties
    public static let identifier = "DailyCitiesForcastCell"
    var degrieScale: DegriesScale?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configeCell(with city:City){
        cityNameLabel.text = city.name
        descriptionLabel.text = city.weather?[0].weatherDescription
        if let weatherIconDescription = city.weather?[0].icon{
            descriptionImageView.image = UIImage(named: weatherIconDescription)
        }
        
        if let main = city.main{
            var minTemp = main.tempMin
            var maxTemp = main.tempMax
            var degrieSign = "℃"
            
            if degrieScale == DegriesScale.Fahrenhite{
                minTemp = minTemp * (9/5) + 32
                maxTemp = maxTemp * (9/5) + 32
                degrieSign = "℉"
            }
            
            minMaxTempLabel.text = "\(Int(minTemp)) - \(Int(maxTemp))" + degrieSign
            
        }
    }

}

