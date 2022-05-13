//
//  ItemStore.swift
//  Lootlogger
//
//  Created by Stéphane Trouvé on 03/05/2022.
//

import UIKit

class ItemStore {
    
    var allItems = [Item]()
    let itemArchiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("Items.plist")
    }()
       
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
        
    }
    
    init() {
        
        loadItems()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didDisconnectNotification, object: nil)
        
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allItems[fromIndex]
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
        
    }
    
    @objc func saveChanges() -> Bool {
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allItems)
            try data.write(to: itemArchiveURL, options: [.atomic])
            print("Saved all items")
            return true
            
        } catch {
            print("Error in saving items: \(error)")
            return false
        }
        
    }
    
    func loadItems() {
        
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let decoder = PropertyListDecoder()
            let items = try decoder.decode([Item].self, from: data)
            allItems = items
        } catch {
            print("Error in loading: \(error)")
        }
        
    }
    
}
