//
//  Extensions+ActivityIndicator.swift
//  WeatherApp
//
//  Created by Yoni on 13/06/2020.
//  Copyright © 2020 Yoni. All rights reserved.
//

import UIKit
extension UIActivityIndicatorView{
    func setup(with view:UIView){
        self.layer.position = view.center
        self.style = .large
        self.color = .black
        self.hidesWhenStopped = true
        view.addSubview(self)
        self.startAnimating()
        
    }
}
