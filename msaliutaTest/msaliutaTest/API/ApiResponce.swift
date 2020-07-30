//
//  ApiResponce.swift
//  msaliutaTest
//
//  Created by Maksym Saliuta on 29.07.2020.
//  Copyright © 2020 Maksym Saliuta. All rights reserved.
//

import Foundation
import UIKit

struct ApiResponce: Codable {
    var code: Int
    var data: String
    var err: Bool
}

struct AppsResponse: Codable {
    var data: [AppsData]
}

struct AppsData: Codable {
    var applicationIcoUrl: String?
    var applicationName: String?
    var applicationUrl: String?
    var isPayment: Bool?
    var applicationStatus: Bool?
}
