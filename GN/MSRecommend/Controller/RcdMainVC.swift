//
//  RcdMainVC.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/3.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result



class RcdMainVC: UITableViewController {
    
    let vm = RcdVM()
    
    var page =  1
    var size = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func loadData()  {
        
        GNHUD.show(GNHUDContentType.label("请等待......"))
        
        vm.getRecommendList(page: page, size: size).observeCompleted {
            GNHUD.flash(GNHUDContentType.success, delay: 1.0)
            self.tableView.reloadData()
        }
       
    }
    func setupUI()  {
        
        tableView.register(UINib.init(nibName: "MSListCell", bundle: nil), forCellReuseIdentifier: "MSRecommendCell")
        tableView.delegate = self
        tableView.dataSource = self

        
        let view = RcdScrollView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 150))
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 150))
        self.tableView.tableHeaderView = v
        self.tableView.tableHeaderView?.addSubview(view)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return
    //    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  vm.tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MSListCell  = tableView.dequeueReusableCell(withIdentifier: "MSRecommendCell", for: indexPath) as! MSListCell
        
        cell.model = vm.tableArray[indexPath.row] as? RcdModel
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        return 100
//    }

    
    
    
}
