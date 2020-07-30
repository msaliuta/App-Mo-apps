//
//  AppListViewController.swift
//  msaliutaTest
//
//  Created by Maksym Saliuta on 30.07.2020.
//  Copyright © 2020 Maksym Saliuta. All rights reserved.
//

import UIKit
import SafariServices

class AppListViewController: UIViewController {

    @IBOutlet weak var appListTableView: UITableView!
    
    let api = Api()
    var projectResponse: AppsResponse? = nil
    var userToken: String?
    let cellId = "appListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    func configureTableView() {
        appListTableView.delegate = self
        appListTableView.dataSource = self
        appListTableView.backgroundView = UIImageView(image: UIImage(named: "bgr"))
        appListTableView.register(UINib(nibName: "AppListCellTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bgr"), for: .default)
        request()
    }
    
    func request() {
        let urlString = "https://html5.mo-apps.com/api/application"
        let parameters = ["skip":"0", "take":"1000", "osType":"0","userToken": userToken!]
        self.api.projectRequest(urlString: urlString, parameters: parameters) { [weak self](result) in
            switch result {
            case .success(let projectResponse):
                self?.projectResponse = projectResponse
                self?.appListTableView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }

}

extension AppListViewController: UITableViewDelegate {
    
}

extension AppListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projectResponse?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = projectResponse?.data[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? AppListCell else{
                return UITableViewCell()
        }
        let image = self.api.getImage(from: (data.applicationIcoUrl)!)
        
        cell.configure(with: data, image: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = projectResponse?.data[indexPath.row]

        let vc = SFSafariViewController(url: URL(string: (link?.applicationUrl)! )!)
        present(vc, animated: true)
    }
}
