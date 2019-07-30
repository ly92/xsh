//
//  ContactTableViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/7/25.
//  Copyright © 2019 wwzb. All rights reserved.
//

import UIKit
import Contacts

class ContactTableViewController: BaseTableViewController {

    fileprivate var contacts : Array<CNContact> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "通讯录"
        
        self.tableView.backgroundColor = BG_Color
        self.tableView.separatorStyle = .singleLine
        
        self.getContacts()
        
        
        self.pullToRefre {
            self.contacts.removeAll()
            self.getContacts()
        }
    }
    
    func getContacts() {
        
        let store = CNContactStore()
        
        func request(){
         
            let status = CNContactStore.authorizationStatus(for: .contacts)
            if status != .authorized{
                LYProgressHUD.showError("授权失败！")
                return
            }
            
            let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey,
                        CNContactOrganizationNameKey, CNContactJobTitleKey,
                        CNContactDepartmentNameKey, CNContactNoteKey, CNContactPhoneNumbersKey,
                        CNContactEmailAddressesKey, CNContactPostalAddressesKey,
                        CNContactDatesKey, CNContactInstantMessageAddressesKey
            ]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            do{
                try store.enumerateContacts(with: request) { (contact, stop) in
                    self.contacts.append(contact)
                }
            }catch{
                
            }
            
        }
        store.requestAccess(for: .contacts) { (isOk, error) in
            if isOk{
               request()
            }else{
                LYAlertView.show("提示", "未允访问通讯录请在设置中允许访问", "取消", "确定",{
                    let url = URL(string:UIApplication.openSettingsURLString)
                    if UIApplication.shared.canOpenURL(url!){
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                })
                return
            }
        }
        self.tableView.reloadData()
    }
    
    
    func deleteAction(contact : CNContact, index : Int) {
        let request = CNSaveRequest()
        request.delete(contact.mutableCopy() as! CNMutableContact)
        let store = CNContactStore()
        do {
            try store.execute(request)
        }catch{
            LYProgressHUD.showError("删除失败！")
        }
        
        self.contacts.remove(at: index)
        self.tableView.reloadData()
    }
    
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "contactCell")
        if self.contacts.count > indexPath.row{
            let contact = self.contacts[indexPath.row]
            cell.textLabel?.text = contact.familyName + contact.givenName + contact.nickname + contact.organizationName
            var phones : Array<String> = []
            for phone in contact.phoneNumbers {
                //获取号码
                let value = phone.value.stringValue
                phones.append(value)
            }
            cell.detailTextLabel?.text = phones.joined(separator: ",")
        }
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            if self.contacts.count > indexPath.row{
                let contact = self.contacts[indexPath.row]
                self.deleteAction(contact: contact, index: indexPath.row)
            }
        }
    }
    

}



