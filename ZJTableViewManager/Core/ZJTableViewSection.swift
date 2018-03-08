//
//  ZJTableViewSection.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

class ZJTableViewSection: NSObject {
    weak var tableViewManager: ZJTableViewManager!
    var items: [Any]!
    var headerHeight: CGFloat!
    var footerHeight: CGFloat!
    var headerView: UIView?
    var footerView: UIView?
    
    override init() {
        super.init()
        self.items = []
        self.headerHeight = CGFloat.leastNormalMagnitude
        self.footerHeight = CGFloat.leastNormalMagnitude
    }
    
    convenience init(headerHeight: CGFloat!, color: UIColor) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
        headerView.backgroundColor = color
        self.init(headerView: headerView, footerView: nil)
    }
    
    convenience init(headerView: UIView!) {
        self.init(headerView: headerView, footerView: nil)
    }
    
    convenience init(footerView: UIView?) {
        self.init(headerView: nil, footerView: footerView)
    }

    convenience init(headerView: UIView?, footerView: UIView?) {
        self.init()
        if let header = headerView {
            self.headerView = header
            self.headerHeight = header.frame.size.height
        }
        
        if let footer = footerView {
            self.footerView = footer
            self.footerHeight = footer.frame.size.height
        }
    }
    
    func add(item: Any) {
        (item as! ZJTableViewItem).section = self
        self.items.append(item)
    }
    
    func remove(item: Any) {
        self.items.remove(at: self.items.index(where: { (obj) -> Bool in
            return (obj as! ZJTableViewItem) == (item as! ZJTableViewItem)
        })!)
    }
    
    func removeAllItems() {
        self.items.removeAll()
    }
    
    func replaceItemsFrom(array: [Any]!) {
        self.removeAllItems()
        self.items = self.items + array
    }
    
    func reload(_ animation: UITableViewRowAnimation) {
        tableViewManager.tableView.beginUpdates()
        tableViewManager.tableView.reloadSections(IndexSet(integer: tableViewManager.sections.index(where: { (item) -> Bool in
            return (item as! ZJTableViewSection) == self
        })!), with: animation)
        tableViewManager.tableView.endUpdates()
    }
    
}