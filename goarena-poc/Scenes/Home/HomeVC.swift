//
//  HomeVC.swift
//  goarena-poc
//
//  Created by serhat akalin on 27.01.2021.
//

import UIKit

class HomeVC: BaseVC<HomeViewModel> {
    @IBOutlet weak var wallTableView: UITableView!
    private var refresher: UIRefreshControl!
    private var currentPage: Int = 0
    private var hasNextPage = true
    var isDownloadedBefore = false
    var pageLimit: Int? = 0
    var lockScreen = false
    var response = [Content]()
    var topRefresh = false
    var userID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        onSubscribe()

        viewModel.getContents()
        wallTableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        wallTableView.backgroundColor = UIColor.init(hexString: "#F3F6FA")
        wallTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 85, right: 0)
        wallTableView.separatorStyle = .none
        // MARK: Pull to refresh
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.blue
        refresher.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        wallTableView.addSubview(refresher)
    }

    private func onSubscribe() {
        SwiftEventBus.onMainThread(self, name: SubscribeViewState.FEED_STATE.rawValue) { result in
            if let event = result!.object as? WallResponse {
                if event.content.count > 0 {
                    let data = event.content.filter({ $0.text != nil || $0.preview != nil })
                    for d in data {
                        self.response.append(d)
                    }
                    self.pageLimit = event.totalPages
                    self.wallTableView.reloadData()
                }
            }
        }

        SwiftEventBus.onMainThread(self, name: SubscribeViewState.FEED_REFRESH.rawValue) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.viewModel.getContents()
                })
        }

    }


    @IBAction func openCharts(_ sender: Any) {
        print("charts..")

    }

    @IBAction func openNewFeed(_ sender: Any) {
        navFeed()
    }

    func navFeed(_ image: String? = "", text: String? = "") {
        guard let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "NewFeedVC") as? NewFeedVC else { return }
        vc.updateText = text
        vc.updateImage = image
        guard let nc = self.navigationController else { return }
        nc.pushViewController(vc, animated: true)
    }

    func navDetail(_ post: Content?) {
        guard let post = post else { return }
        guard let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "HomeDetailVC") as? HomeDetailVC else { return }
        vc.text = post.text
        vc.image = post.preview
        guard let nc = self.navigationController else { return }
        nc.pushViewController(vc, animated: true)
    }

    private func reloadView() {
        if hasNextPage {
            let lastItem = response.count - 1
            if pageLimit != lastItem {
                if currentPage < pageLimit ?? 10 {
                    currentPage += 1
                    hasNextPage = pageLimit != currentPage
                    if topRefresh {
                        currentPage = 0
                    }
                    viewModel.pageNumber = currentPage
                    viewModel.getContents()
                }
            }
            wallTableView.reloadData()
            refresher.endRefreshing()
        } else {
            wallTableView.reloadData()
            refresher.endRefreshing()
        }

    }

    @objc
    func pullToRefresh() {
        refresher.beginRefreshing()
        topRefresh = true
        reloadView()
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        let post = response[indexPath.row]
        if post.text != nil && post.preview != nil {
            return UITableViewCell()
        }
        print("POST _>", post.text, post.preview)
        cell.setup(post, tableWidth: wallTableView.frame.width)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = response[indexPath.row]
        if post.userId == userID {
            let alert = UIAlertController(title: "Seçenekler", message: "Düzenlemeler", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Güncelle", style: .default, handler: { (UIAlertAction)in
                self.navFeed(post.preview, text: post.text)
            }))
            alert.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: { (UIAlertAction)in
                self.viewModel.deletePost(post.id)
            }))
            alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: { (UIAlertAction)in
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            navDetail(post)
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
            reloadView()
        }
    }
}
