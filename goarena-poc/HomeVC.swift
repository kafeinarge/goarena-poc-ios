//
//  HomeVC.swift
//  goarena-poc
//
//  Created by serhat akalin on 27.01.2021.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var wallTableView: UITableView!
    private var refresher: UIRefreshControl!
    private var currentPage: Int = 0
    private var hasNextPage = false
    private var isNewPageLoading: Bool = false
    var isDownloadedBefore = false
    var lockScreen = false
    var response: [Content]?
    var wallApi = WallAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wallApi.getWallService(lockScreen: lockScreen,
            succeed: handleResponse,
            failed: handleErrorResponse)
        wallTableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        wallTableView.backgroundColor = UIColor.init(hexString: "#F3F6FA")
        wallTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 85, right: 0)
        wallTableView.separatorStyle = .none

        // MARK: Pull to refresh
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.systemBlue
        refresher.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        wallTableView.addSubview(refresher)
        loadPosts(currentPage)
        
    }
    
    
    func getContents() {
        getUserDefaults()
        if response != nil {
            isDownloadedBefore = true
        } else {
            lockScreen = true
        }
        
        wallApi.getWallService(lockScreen: lockScreen,
            succeed: handleResponse,
            failed: handleErrorResponse)
     
    }

    func handleResponse(response: WallResponse) {
        self.response = response.content
        self.wallTableView.reloadData()
    }

    func handleErrorResponse(response: ErrorMessage) {
        print(response.error)
        print(response.message)
    }

    func saveImagesToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(encoded, forKey: "wallContents")
        }
    }

    func getUserDefaults() {
        if let jsonData = UserDefaults.standard.value(forKey: "wallContents") as? Data,
            let obj = try? JSONDecoder().decode([Content].self, from: jsonData) {
            response = obj
        }
    }

    
    private func reloadCollectionView() {
        if isNewPageLoading {
            wallTableView.reloadSections(IndexSet.init(integer: 0), with: .none)
        } else {
            wallTableView.reloadData()
        }
        isNewPageLoading = false
    }

    func loadPosts(_ page: Int = 0) {
        isNewPageLoading = page > 0
        //presenter?.load(page: page, needLoading: true)
    }

    @objc
    func pullToRefresh() {

    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        guard (response?.count)! > indexPath.row else { return cell }
        if let post = response?[indexPath.row] {
            cell.setup(post, tableWidth: wallTableView.frame.width)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let post = response?[indexPath.row] {
            print(post.user)
            //presenter?.showPostDetail(post)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeVC: UIScrollViewDelegate {
    //paging
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.size.height && hasNextPage) {
            currentPage += 1
            //loadPosts(currentPage)
        }
    }
}
