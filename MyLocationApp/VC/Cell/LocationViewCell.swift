//
//  LocationViewCell.swift
//  MyLocationApp
//
//  Created by 황신택 on 2022/03/21.
//

import UIKit

class LocationViewCell: UITableViewCell {
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.contentMode = .scaleAspectFill
        // Rounded corners for images
        photoImageView.layer.cornerRadius = photoImageView.bounds.size.width / 2
        separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)
    }

    
    func configure(model: Location) {
        if model.locationDescription.isEmpty {
            descLabel.text = "No Description!!"
        } else {
            descLabel.text = model.locationDescription
            photoImageView.image = thumbnail(for: model)
        }
        if let placemark = model.placemark {
            var text = ""
               text.add(text: placemark.subThoroughfare)
               text.add(text: placemark.thoroughfare, separatedBy: " ")
               text.add(text: placemark.locality, separatedBy: ", ")
               addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Lat: %.8f", "Long: %.8f",
                                       model.latitude,
                                       model.latitude)
        }
    }
    
    
    func thumbnail(for location: Location) -> UIImage {
      if location.hasPhoto, let image = location.photoImage {
          return image.resized(withBounds: CGSize(width: 52, height: 52))
      }
        return UIImage(named: "No Photo")!
    }

}

