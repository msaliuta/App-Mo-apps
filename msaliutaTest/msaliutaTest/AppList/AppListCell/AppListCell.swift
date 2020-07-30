//
//  AppListCellTableViewCell.swift
//  msaliutaTest
//
//  Created by Maksym Saliuta on 30.07.2020.
//  Copyright © 2020 Maksym Saliuta. All rights reserved.
//

import UIKit

class AppListCell: UITableViewCell {

    @IBOutlet weak var endOfPaymentLabel: UILabel!
    @IBOutlet weak var endOfPaymentImage: UIImageView!
    @IBOutlet weak var applicationStatusLabel: UILabel!
    @IBOutlet weak var applicationStatusImage: UIImageView!
    @IBOutlet weak var applicationNameLabel: UILabel!
    @IBOutlet weak var appLogoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with appListData: AppsData?, image: UIImage?){
        applicationNameLabel.text = appListData?.applicationName
        applicationStatusLabel.text = appListData?.applicationStatus == false ? "Не закончено" : "Закончено"
        applicationStatusImage.image = appListData?.applicationStatus == false ? UIImage(named: "noFinished") :
        UIImage(named: "finished")
        endOfPaymentLabel.text = appListData?.isPayment == false ? "Не оплачено" : "Оплачено"
        endOfPaymentImage.image = appListData?.isPayment == false ? UIImage(named: "nopaid") : UIImage(named: "paid")
        appLogoImage.image = image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
