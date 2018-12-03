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
        
        self.title = "Home"
        
        containersTable.dataSource = self
        containersTable.delegate = self
        
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(refreshContainerList), for: .allEvents)
        containersTable.refreshControl = refreshControl
        
        let nib = UINib.init(nibName: "ContainerCell", bundle: nil)
        containersTable.register(nib, forCellReuseIdentifier: "ContainerCell")
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addContainer))
        navigationItem.rightBarButtonItems = [addButton]
        
        let logoutButton = UIBarButtonItem(barButtonSystemItem: .done,
                                           target: self,
                                           action: #selector(logout))
        navigationItem.leftBarButtonItems = [logoutButton]
    }
    
    @objc func logout() {
        UserSettings.logout()
        let loginVC = LoginViewController()
        navigationController?.setAnimationType(type: FadingAnimation.self, forever: false)
        navigationController?.viewControllers = [loginVC]
    }
    
    @objc func addContainer() {
        let newVC = NewContainerViewController()
        self.present(newVC, animated: true)
    }
    
    @objc func refreshContainerList() {
        containersTable.refreshControl?.beginRefreshing()
        reloadContainers { [weak self] in
            self?.containersTable.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        containersTable.refreshControl?.sendActions(for: .allEvents)
    }
    
    func reloadContainers(_ completion: (() -> ())?=nil) {
        RestAPI.listContainers(completionHandler: { [weak self] containers in
            self?.containers = containers
            self?.containersTable.reloadData()
            completion?()
            }, errorHandler: handleError)
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
        guard let cell =
            containersTable.dequeueReusableCell(withIdentifier: "ContainerCell")
                as? ContainerCell else {
                    return UITableViewCell()
        }
        cell.selectionStyle = .none
        let containerInfo = containers[indexPath.row]
        cell.setup(containerInfo)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let containerID = containers[indexPath.row].id
        let handler: UIContextualAction.Handler = { (action, view, completion) in
//            guard let strongSelf = self else { return }
            // strongSelf.navigationController?.didStartLoading(immediately: true)
            RestAPI.deleteContainer(id:containerID,
                                    completionHandler: {
                                        // strongSelf?.navigationController?.didFinishLoading()
                                        completion(true)
            }, errorHandler: { _ in
                DispatchQueue.main.async {
                    // strongSelf.navigationController?.didFinishLoading()
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
        let container = containers[indexPath.row]
        let containerVC = ContainerViewController(container: container)
        navigationController?.pushViewController(containerVC, animated: true)
    }
}
