//
//  ViewController.swift
//  listapp
//
//  Created by osman efe on 11.02.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var veri = [NSManagedObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        // Do any additional setup after loading the view.
        fetch()
    }


    @IBAction func additembutton(_ sender: UIBarButtonItem) {
        
        let defaultbutton = UIAlertController(title: "yeni eleman ekle", message: nil, preferredStyle: .alert)
        let warningalert = UIAlertController(title: "UYARI", message: "bos birakma amcik", preferredStyle: .alert)
        let tamamabi = UIAlertAction(title: "tamam abi", style: .cancel)
        warningalert.addAction(tamamabi)
        
        let inputbutton = UIAlertAction(title: "ekle", style: .default) { _ in
            let input = defaultbutton.textFields?.first?.text
            if input != "" {
                //self.veri.append((input)!)
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                
                let managedobjectcontext = appdelegate?.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedobjectcontext!)
                
                let listitem = NSManagedObject(entity: entity!, insertInto: managedobjectcontext)
                
                listitem.setValue(input, forKey: "title")
                
                try? managedobjectcontext?.save()
                
                self.fetch()
                
                print("İTEM ADDED")
            }
            else {
                self.present(warningalert, animated: true)
                print("HOLDER FREE")
            }
        }
        
        let cancelbutton = UIAlertAction(title: "vazgec", style: .cancel)
        
        defaultbutton.addTextField()
        defaultbutton.addAction(inputbutton)
        defaultbutton.addAction(cancelbutton)
        //present(defaultbutton, animated: true)
        let cancelledbutton = {
            self.present(defaultbutton, animated: true)
            print("CANCELLED")
        }
        cancelledbutton()
    }
    @IBAction func removeitems(_ sender: UIBarButtonItem) {
        let removealert = UIAlertController(title: "sileyim mi gardaşım", message: nil, preferredStyle: .alert)
        let cancelbutton = UIAlertAction(title: "boşver silme abi", style: .cancel)
        let removebutton = UIAlertAction(title: "kalbimden silme abim", style: .destructive) { _ in
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
                        
                        let managedobjectcontext = appdelegate?.persistentContainer.viewContext
                        
                        for item in self.veri {
                            managedobjectcontext?.delete(item)
                        }
                        
                        try? managedobjectcontext?.save()
                        
                        self.fetch()
                        print("İTEMS REMOVED")
            }
        removealert.addAction(removebutton)
        removealert.addAction(cancelbutton)
        self.present(removealert, animated: true)
        
        }
    func fetch() {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        let managedobjectcontext = appdelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        veri = try! managedobjectcontext!.fetch(request)
        tableview.reloadData()
    }
    
    }

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return veri.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultcell", for: indexPath)
        let Listİtem = veri[indexPath.row]
        cell.textLabel?.text = Listİtem .value(forKey: "title") as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteitems = UIContextualAction(style: .normal, title: "sil") { _, _, _ in
            //self.veri.remove(at: indexPath.row)
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            
            let managedobjectcontext = appdelegate?.persistentContainer.viewContext
            
            managedobjectcontext?.delete(self.veri[indexPath.row])
            
            try? managedobjectcontext?.save()
            
            self.fetch()
            print("İTEM REMOVED")
            
        }
        let defaultbutton = UIAlertController(title: "düzenle", message: nil, preferredStyle: .alert)
        let warningalert = UIAlertController(title: "UYARI", message: "bos birakma amcik", preferredStyle: .alert)
        let tamamabi = UIAlertAction(title: "tamam abi", style: .cancel)
        warningalert.addAction(tamamabi)
        let cancelbutton = UIAlertAction(title: "vazgec", style: .cancel)
        let inputbutton = UIAlertAction(title: "ekle", style: .default) { _ in
            let input = defaultbutton.textFields?.first?.text
            if input != "" {
                //self.veri[indexPath.row] = input!
                
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                
                let managedobjectcontext = appdelegate?.persistentContainer.viewContext
                
                self.veri[indexPath.row].setValue(input, forKey: "title")
                
                if managedobjectcontext!.hasChanges {
                    try? managedobjectcontext?.save()
                    print("İTEM CHANGED")
                }
                
                self.tableview.reloadData()
            }
            else {
                self.present(warningalert, animated: true)
                print("HOLDER FREE")
            }
        }
        
        let configureitems = UIContextualAction(style: .normal, title: "düzenle") { _, _, _ in
            defaultbutton.addTextField()
            defaultbutton.addAction(inputbutton)
            defaultbutton.addAction(cancelbutton)
            self.present(defaultbutton, animated: true)
        }
        deleteitems.backgroundColor = .systemRed
            
        let config = UISwipeActionsConfiguration(actions: [deleteitems, configureitems])
        return config
    }
        
        
        
            
        }

    



