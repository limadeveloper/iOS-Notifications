//
//  HomeViewController.swift
//  iOSNotifications
//
//  Created by John Lima on 12/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var notificationsButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    
    private var nfmanager = NFManager()
    private var deviceToken = String()
    private var notificationsArray = [NotificationModel]()
    private let refresh = UIRefreshControl()
    private let cellName = "cell"
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let center = NotificationCenter.default
        
        center.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: .main) { (notification) in
            self.checkNotificationSettings()
        }
        
        center.addObserver(forName: NSNotification.Name(rawValue: Constants.Notification.registerToken), object: nil, queue: .main) { (notification) in
            self.checkNotificationSettings()
            center.removeObserver(self, name: NSNotification.Name(rawValue: Constants.Notification.registerToken), object: nil)
        }
        
        center.addObserver(forName: NSNotification.Name(rawValue: Constants.Notification.receiveRemoteNotification), object: nil, queue: .main) { (notification) in
            self.getData()
            center.removeObserver(self, name: NSNotification.Name(rawValue: Constants.Notification.registerToken), object: nil)
        }
    }
    
    // MARK: - Actions
    @IBAction private func enableNotifications(sender: UIBarButtonItem) {
        guard notificationsButton.tag == 0 else { return }
        nfmanager.registerNotifications(target: self)
    }
    
    private func updateUI() {
        
        let footer = UIView(frame: .zero)
        
        refresh.tintColor = Constants.Colors.defaultApp
        refresh.addTarget(self, action: #selector(getData), for: .valueChanged)
        
        tableView.tableFooterView = footer
        tableView.backgroundColor = .white
        tableView.allowsSelection = notificationsArray.count > 0
        tableView.refreshControl = refresh
    }
    
    @objc private func getData() {
        self.notificationsArray = NotificationModel.getData() ?? []
        self.tableView.reloadData()
        self.refresh.endRefreshing()
    }
    
    private func checkNotificationSettings() {
        nfmanager.notificationSettings { (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.notificationsButton.image = #imageLiteral(resourceName: "NotificationOn")
                    self.notificationsButton.tag = 1
                    guard let deviceToken = UserDefaults.standard.value(forKey: Constants.DataKey.notificationToken) as? String else { return }
                    print("\(NSLocalizedString(Constants.Texts.deviceToken, comment: "")): \(deviceToken)")
                    self.deviceToken = deviceToken
                default:
                    self.notificationsButton.image = #imageLiteral(resourceName: "NotificationOff")
                    self.notificationsButton.tag = 0
                }
            }
        }
    }
}

// MARK: - TableView DataSource and Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count > 0 ? notificationsArray.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! HomeTableViewCell
        
        guard notificationsArray.count > 0 else { cell.data = nil; return cell }
        
        cell.data = notificationsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
