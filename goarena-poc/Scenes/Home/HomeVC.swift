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
    private var hasNextPage = false
    private var isNewPageLoading: Bool = false
    var isDownloadedBefore = false
    var lockScreen = false
    var response: [Content]?
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
        refresher.tintColor = UIColor.systemBlue
        refresher.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        wallTableView.addSubview(refresher)
        loadPosts(currentPage)
    }

    private func onSubscribe() {
        SwiftEventBus.onMainThread(self, name: SubscribeViewState.FEED_STATE.rawValue) { result in
            if let event = result!.object as? WallResponse {
                if event.content.count > 0 {
                    self.response = event.content
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
        if isNewPageLoading {
            wallTableView.reloadSections(IndexSet.init(integer: 0), with: .none)
        } else {
            wallTableView.reloadData()
        }
        isNewPageLoading = false
    }

    func loadPosts(_ page: Int = 0) {
        isNewPageLoading = page > 0
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
        guard let post = response?[indexPath.row] else { return }
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
        if let post = response?[indexPath.row] {
            if post.preview == nil || post.text == nil {
                return tableView.frame.height / 2
            }
        }
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
