//
//  ContainerViewController.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var itemsTable: UITableView!
    
    let containerID: Int
    let container: ContainerInfo
    
    var items: [FridgeItem] = []
    
    init(container: ContainerInfo) {
        self.containerID = container.id
        self.container = container
        super.init(nibName: nil, bundle: nil)
        self.title = container.name.capitalized
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsTable.delegate = self
        itemsTable.dataSource = self
        
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(refreshItemList), for: .allEvents)
        itemsTable.refreshControl = refreshControl
        
        let nib = UINib.init(nibName: "FridgeItemCell", bundle: nil)
        itemsTable.register(nib, forCellReuseIdentifier: "FridgeItemCell")
        
        let infoButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                        target: self,
                                        action: #selector(addItem))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addItem))
        navigationItem.rightBarButtonItems = [infoButton, addButton]
        // Do any additional setup after loading the view.
    }
    
    @objc func addItem() {
        let newVC = NewContainerViewController(container: container)
        self.present(newVC, animated: true)
    }
    
    @objc func editContainer() {
        let newVC = NewItemViewController(containerID: containerID)
        self.present(newVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemsTable.refreshControl?.sendActions(for: .allEvents)
    }

    @objc func refreshItemList() {
        itemsTable.refreshControl?.beginRefreshing()
        RestAPI.getContainer(id: self.containerID,
                             completionHandler: { [weak self] container in
                                self?.items = container.items
                                self?.itemsTable.reloadData()
                                self?.itemsTable.refreshControl?.endRefreshing()
            },errorHandler: handleError)
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


extension ContainerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            itemsTable.dequeueReusableCell(withIdentifier: "FridgeItemCell")
                as? FridgeItemCell else {
                    return UITableViewCell()
        }
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        cell.setup(item)
        return cell
    }
}

extension ContainerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let itemID = items[indexPath.row].id
        let handler: UIContextualAction.Handler = { (action, view, completion) in
            RestAPI.deleteItem(id: itemID,
                                    completionHandler: {
                                        completion(true)
            }, errorHandler: { _ in
                DispatchQueue.main.async {
                    completion(false)
                }
            })
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: handler)
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let newVC = NewItemViewController(containerID: containerID, item: item)
        present(newVC, animated: true)
    }
}
