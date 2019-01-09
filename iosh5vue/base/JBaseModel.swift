//
//  JBaseModel.swift
//  renttravel
//
//  Created by jackyshan on 2018/5/30.
//  Copyright © 2018年 GCI. All rights reserved.
//

import Foundation

protocol JBaseModel: Codable {
    
}

class JTBaseModel: JBaseModel {
    
}

extension JBaseModel {
    //模型转字典
    func toDictionary() -> [String:Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [String:Any]()
        }
        
        guard let dict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else {
            return [String:Any]()
        }
        
        return dict
    }
    
    //字典转模型
    static func initt<T:JBaseModel>(dictionary dict:[String:Any],_ type:T.Type) throws -> T {
        var newDict = dict
        if dict is [String: AnyCodable] {
            let dd: [String: AnyCodable] = dict as! [String : AnyCodable]
            newDict = Dictionary.init(uniqueKeysWithValues: dd.map({key, value in (key, value.value)}))
        }
        
        guard let JSONString = newDict.toJSONString() else {
            print("MapError.dictToJsonFail")
            throw MapError.dictToJsonFail
        }
        guard let jsonData = JSONString.data(using: .utf8) else {
            print(MapError.jsonToDataFail)
            throw MapError.jsonToDataFail
        }

        let decoder = JSONDecoder()
//        if let obj = try? decoder.decode(type, from: jsonData) {
//            return obj
//        }
//        print(MapError.jsonToModelFail)
//        throw MapError.jsonToModelFail
        #if DEBUG
        
        return try! decoder.decode(type, from: jsonData)
        
        #else
        
        if let obj = try? decoder.decode(type, from: jsonData) {
            return obj
        }
        print(MapError.jsonToModelFail)
        throw MapError.jsonToModelFail
        
        #endif
        //        return try! decoder.decode(type, from: jsonData)
    }
    
    //Json转模型
    static func initt<T: JBaseModel>(string jsonSting: String, error: Error?, _ type:T.Type) throws -> T {
        guard let jsonData = jsonSting.data(using: .utf8) else {
            print(MapError.jsonToDataFail)
            throw MapError.jsonToDataFail
        }
        let decoder = JSONDecoder()
//        if let obj = try? decoder.decode(type, from: jsonData) {
//            return obj
//        }
//        print(MapError.jsonToModelFail)
//        throw MapError.jsonToModelFail
        #if DEBUG
        
        return try! decoder.decode(type, from: jsonData)
        
        #else
        
        if let obj = try? decoder.decode(type, from: jsonData) {
            return obj
        }
        print(MapError.jsonToModelFail)
        throw MapError.jsonToModelFail
        
        #endif
//        return try! decoder.decode(type, from: jsonData)
    }
    
    //model转json 字符串
    func toJSONString() -> String {
        guard let data = try? JSONEncoder().encode(self) else {
            return ""
        }
        
        guard let str = String.init(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/") else {
            return ""
        }
        
        return str
    }
}

enum MapError: Error {
    case jsonToModelFail    //json转model失败
    case jsonToDataFail     //json转data失败
    case dictToJsonFail     //字典转json失败
    case jsonToArrFail      //json转数组失败
    case modelToJsonFail    //model转json失败
}

extension Dictionary {
    func toJSONString() -> String? {
        if !JSONSerialization.isValidJSONObject(self) {
            print("dict 转 json 失败")
            return nil
        }
        if let newData:Data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            guard let JSONString = String.init(data: newData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/") else {
                return ""
            }
            
            return JSONString
        }
        print("dict 转 json 失败")
        return nil
    }
}

extension Array {
    func toJSONString() -> String? {
        if !JSONSerialization.isValidJSONObject(self) {
            print("dict转json失败")
            return nil
        }
        if let newData : Data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            guard let JSONString = String.init(data: newData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/") else {
                return ""
            }
            
            return JSONString
        }
        print("dict转json失败")
        return nil
    }
    static func initt<T:Decodable>(string jsonString:String,_ type:[T].Type) throws -> Array<T> {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print(MapError.jsonToDataFail)
            throw MapError.jsonToDataFail
        }
        let decoder = JSONDecoder()
//        if let obj = try? decoder.decode(type, from: JSonData) {
//            return obj
//        }
//        print(MapError.jsonToArrFail)
//        throw MapError.jsonToArrFail
        
        #if DEBUG
        
        return try! decoder.decode(type, from: jsonData)
        
        #else
        
        if let obj = try? decoder.decode(type, from: jsonData) {
            return obj
        }
        print(MapError.jsonToModelFail)
        throw MapError.jsonToModelFail
        
        #endif
        //        return try! decoder.decode(type, from: jsonData)
    }
}

extension String {
    func toDictionary() -> [String:Any]? {
        guard let jsonData:Data = self.data(using: .utf8) else {
            print("json转dict失败")
            return nil
        }
        if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            return dict as? [String : Any] ?? ["":""]
        }
        print("json转dict失败")
        return nil
    }
}
