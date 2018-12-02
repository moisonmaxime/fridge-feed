//
//  HomeViewController.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var containersTable: UITableView!
    
    var containers: [ContainerInfo] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RestAPI.listContainers(completionHandler: { [weak self] containers in
            self?.containers = containers
            self?.containersTable.reloadData()
        }, errorHandler: handleError)

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContainer))
        navigationItem.rightBarButtonItems = [addButton]
        // Do any additional setup after loading the view.
    }
    
    @objc func addContainer() {
        print("ADD")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
