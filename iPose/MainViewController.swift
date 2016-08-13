//
//  ViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/10.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let Titles = ["推荐", "一人", "两人", "多人", "景色", "很多人"]

class MainViewController: IPViewController {
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var dataSource = [PoseItem]()
    var controllers: [PoseChildViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        Alamofire.request(.GET, "http://nahaowan.com/api/v2/haowan/pose/list").responseJSON {[weak self] response in
            guard let strongSelf = self else  { return }
            switch response.result {
            case .Success:
                guard let value = response.result.value else { return }
                for (_,subJson):(String, JSON) in JSON(value)["data"]["list"] {
                    guard let item = PoseItem(subJson) else { continue }
                    strongSelf.dataSource.append(item)
                }
                strongSelf.fillAndReloadChildData()
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        displayControllers()
    }
}

//MARK: PoseChildViewControllerDelegate
extension MainViewController: PoseChildViewControllerDelegate {
    func poseItemSelected(poseItem: PoseItem, controllerIndex: Int) {
        print("\(poseItem.poseImage)  controllerIndex: \(controllerIndex)")
    }
}

//MARK: UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
        }
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategoryLabelCollectionCell
        cell.titleLabel.text = Titles[indexPath.row]
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Titles.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        showChildControllerByIndex(indexPath.row)
    }
}

//MARK: Private 
extension MainViewController {
    private func setupUI() {
        setupCollectionViewLatout()
        automaticallyAdjustsScrollViewInsets = false
    }
    private func displayControllers() {
        if controllers.count > 0 { return }
        let contentSize = CGSize(width: ScreenWidth * CGFloat(Titles.count), height: scrollView.frame.height)
        scrollView.contentSize = contentSize
        
        var i: Int = 0
        var x: CGFloat = 0
        for _ in Titles {
            x = CGFloat(i) * ScreenWidth
            guard let controller = storyboard?.instantiateViewController(PoseChildViewController) else { return }
            addChildViewController(controller)
            controller.view.frame = CGRect(x: x, y: 0, width: ScreenWidth, height: scrollView.frame.height)
            scrollView.addSubview(controller.view)
            controller.didMoveToParentViewController(self)
            controller.index = i
            controller.delegate = self
            controllers.append(controller)
            i = i + 1
        }
    }
    private func setupCollectionViewLatout() {
        let flowLayout = topCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: 100, height: 50)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
    }
    private func currentShowControllerIndex() -> Int {
        let contentOffset = scrollView.contentOffset
        let index = Int(contentOffset.y / ScreenWidth)
        return index
    }
    private func showChildControllerByIndex(index: Int) {
        UIView.animateWithDuration(0.25) {
            self.scrollView.contentOffset = CGPoint(x: CGFloat(index) * ScreenWidth , y: 0)
        }
    }
    private func fillAndReloadChildData() {
        if controllers.count <= 0  { return }
        for controller in self.controllers {
            controller.dataSource = dataSource
            controller.collection.reloadData()
        }
    }
}