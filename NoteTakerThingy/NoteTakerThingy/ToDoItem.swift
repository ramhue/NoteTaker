//
//  MyToDo.swift
//  NoteTakerThingy
//
//  Created by CampusUser on 3/13/19.
//  Copyright © 2019 ramhue. All rights reserved.
//

import Foundation

class ToDoItem: NSObject, NSCoding{
    var title: String
    var done: Bool
    
    public init(title: String){
        self.title = title
        self.done = false
    }
    required init?(coder aDecoder: NSCoder){
        if let title = aDecoder.decodeObject(forKey: "title") as? String{
            self.title = title
        }
        else{
        
            return nil
        }
            if aDecoder.containsValue(forKey: "done"){
            self.done = aDecoder.decodeBool(forKey: "done")
        }
        else{
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.done, forKey: "done")
    }
}

extension ToDoItem
{
    public class func getMockData() -> [ToDoItem]
    {
        return [
            ToDoItem(title: "Milk"),
            ToDoItem(title: "Chocolate"),
            ToDoItem(title: "Light bulb"),
            ToDoItem(title: "Dog food")
        ]
    }
}

extension Collection where Iterator.Element == ToDoItem
{
    private static func persistencePath() -> URL?
    {
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        
        return url?.appendingPathComponent("todoitems.bin")
    }
    
    // Write the array to persistence
    func writeToPersistence() throws
    {
        if let url = Self.persistencePath(), let array = self as? NSArray
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        }
        else
        {
            throw NSError(domain: "com.example.MyToDo", code: 10, userInfo: nil)
        }
    }
    
    // Read the array from persistence
    static func readFromPersistence() throws -> [ToDoItem]
    {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?)
        {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ToDoItem]
            {
                return array
            }
            else
            {
                throw NSError(domain: "com.example.MyToDo", code: 11, userInfo: nil)
            }
        }
        else
        {
            throw NSError(domain: "com.example.MyToDo", code: 12, userInfo: nil)
        }
    }
}

extension ToDoItem{
    public class func getFakeNews()-> [ToDoItem] {
        return[
            ToDoItem(title: "Milk"),
            ToDoItem(title: "eggs"),
            ToDoItem(title: "butter"),
            ToDoItem(title: "Dog Food"),
        ]
    }
}
