//
//  Item.swift
//  Tasky
//
//  Created by Akhadjon Abdukhalilov on 9/10/20.
//  Copyright © 2020 Akhadjon Abdukhalilov. All rights reserved.
//

import Foundation

class Task :Encodable, Decodable{
    var title:String = ""
    var done:Bool = false
}
