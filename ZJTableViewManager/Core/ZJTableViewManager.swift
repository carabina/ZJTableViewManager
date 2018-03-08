//
//  ZJTableViewManager.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

class ZJTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    var tableView:UITableView!
    var sections: [Any] = []
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.registerDefaultCells()
    }
    
    func registerDefaultCells() {
        self.register(ZJTextCell.self, ZJTextItem.self)
        self.register(ZJTextFieldCell.self, ZJTextFieldItem.self)
        self.register(ZJSwitchCell.self, ZJSwitchItem.self)
    }
    
    func register(_ nibClass: AnyClass, _ item:AnyClass) {
        if (Bundle.main.path(forResource: "\(nibClass)", ofType: "nib") != nil) {
            self.tableView.register(UINib.init(nibName: "\(nibClass)", bundle: nil), forCellReuseIdentifier: NSStringFromClass(item))
        }else{
            self.tableView.register(nibClass, forCellReuseIdentifier: NSStringFromClass(item))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let currentSection = sections[section] as! ZJTableViewSection
        return currentSection.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentSection = sections[section] as! ZJTableViewSection
        return currentSection.headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let currentSection = sections[section] as! ZJTableViewSection
        return currentSection.footerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let currentSection = sections[section] as! ZJTableViewSection
        return currentSection.footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section] as! ZJTableViewSection
        return currentSection.items.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = sections[indexPath.section] as! ZJTableViewSection
        let item = currentSection.items[indexPath.row] as! ZJTableViewItem
        return item.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section] as! ZJTableViewSection
        let item = currentSection.items[indexPath.row] as! ZJTableViewItem
        item.indexPath = indexPath
        item.tableViewManager = self
        //报错在这里，可能是是没有register cell 和 item
        var cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier) as? ZJTableViewCell
        
        if let systemCell = item.systemCell {
            if cell == nil {
                cell = ZJTableViewCell(style: item.systemCellStyle!, reuseIdentifier: item.cellIdentifier)
            }
            self.transform(fromLabel: systemCell.textLabel, toLabel: cell?.textLabel)
            self.transform(fromLabel: systemCell.detailTextLabel, toLabel: cell?.detailTextLabel)
        }
        
        if let separatorInset = item.separatorInset {
            cell?.separatorInset = separatorInset
        }
        
        if let accessoryType = item.accessoryType {
            cell?.accessoryType = accessoryType
        }else{
            cell?.accessoryType = .none
        }
        
        if let selectionStyle = item.selectionStyle {
            cell?.selectionStyle = selectionStyle
        }
        
        cell?.item = item
        cell?.cellWillAppear()
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("didEndDisplaying")
        (cell as! ZJTableViewCell).cellDidDisappear()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("willDisplay")
        (cell as! ZJTableViewCell).cellDidAppear()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = sections[indexPath.section] as! ZJTableViewSection
        let item = currentSection.items[indexPath.row] as! ZJTableViewItem
        if item.isSelectionAnimate {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        item.selectionHandler?(item)
    }
    
    func add(section: Any) {
        (section as! ZJTableViewSection).tableViewManager = self
        self.sections.append(section)
    }
    
    func reload() {
        self.tableView.reloadData()
    }
    
    func transform(fromLabel:UILabel?, toLabel:UILabel?) {
        toLabel?.text = fromLabel?.text
        toLabel?.font = fromLabel?.font
        toLabel?.textColor = fromLabel?.textColor
        toLabel?.textAlignment = (fromLabel?.textAlignment)!
        if let string = fromLabel?.attributedText {
            toLabel?.attributedText = string
        }
    }
}