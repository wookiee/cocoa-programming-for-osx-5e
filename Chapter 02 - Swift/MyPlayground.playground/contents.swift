// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"
str = "Hello, Swift"
let constStr = str

var nextYear: Int
var bodyTemp: Float
var hasPet: Bool

var arrayOfInts: [Int]
var dictionaryOfCapitalsByCountry: [String:String]
var winningLotteryNumbers: Set<Int>

//: # Literals and Subscripting

let number = 42
let fmStation = 91.1

let countingUp = ["one", "two"]
let secondElement = countingUp[1]
let nameByParkingSpace = [13: "Alice", 27: "Bob"]
//let spaceAssignee = nameByParkingSpace[13]
if let spaceAssignee = nameByParkingSpace[13] {
    print("Key 13 was in the dictionary!")
}

//: # Initializers

let emptyString = String()
let emptyArrayOfInts = [Int]()
let emptySetOfFloats = Set<Float>()



let defaultNumber = Int()
let defaultBool = Bool()

let meaningOfLife = String(42)

let availableRooms = Set([205, 411, 412])

let defaultFloat = Float()
let floatFromLiteral = Float(3.14)

let easyPi = 3.14
let floatFromDouble = Float(easyPi)
let floatingPi: Float = 3.14


let reading1: Float? = 9.8
let reading2: Float? = 9.2
let reading3: Float? = 9.7

if let r1 = reading1,
    let r2 = reading2,
    let r3 = reading3 {
    let avgReading = (r1 + r2 + r3) / 3
} else {
    let errorString = "Instrument reported a reading that was nil."
}

//: # Control Flow


if defaultBool {
    // do something
}
else {
    // do something else
}

for i in 0 ..< countingUp.count {
    let string = countingUp[i]
}

let range = 0..<countingUp.count
for i in range {
    let string = countingUp[i]
}

for string in countingUp {
    
}

for (i, string) in countingUp.enumerated() {
    
}

//: # String Interpolation

for (space, name) in nameByParkingSpace {
    let permit = "Space \(space): \(name)"
}



enum PieType {
    case apple
    case cherry
    case pecan
}
let favoritePie = PieType.apple

var piesToBake: [PieType] = []
piesToBake.append(.apple)

let name: String
switch favoritePie {
case .apple:
    name = "Apple"
case .cherry:
    name = "Cherry"
case .pecan:
    name = "Pecan"
}


enum PieTypeInt: Int {
    case apple = 0
    case cherry = 1
    case pecan = 2
}
let pieRawValue = PieTypeInt.pecan.rawValue
if let pie = PieTypeInt(rawValue: pieRawValue) {
    
}
