import UIKit

let defaults = UserDefaults.standard

defaults.set(0.24, forKey: "Volume")// seting default volume for app
defaults.set(true, forKey: "MusicOn")
defaults.set("Marshall", forKey: "PlayerName")
defaults.set(Date(), forKey: "AppLastOpened")
let array = [1,2,3]
defaults.set(array, forKey: "myArray")
let dictionary = ["name":"Marshall"]
defaults.set(dictionary, forKey: "myDictionay")




let volume = defaults.float(forKey: "Volume")
let appLastOpened = defaults.object(forKey: "AppLastOpened")
let myArray = defaults.array(forKey: "myArray") as! [Int]
let myDictionary = defaults.dictionary(forKey: "myDictionay")

//SINGLETONS
class Car{
    var colour = "red"
}

let myCar = Car()
myCar.colour = "blue"

let yourCar = Car()
print(yourCar.colour)
print(myCar.colour)

class CarSingleton {
    var colour = "red"
    
    static let singletonCar = CarSingleton()
}

let myCarSingleton = CarSingleton.singletonCar
myCarSingleton.colour = "blue"

let yourCarSingleton = CarSingleton.singletonCar
print(yourCarSingleton.colour)// colour remains blue instead of red since we changed it..the DOTstandard in front of UseDefaults makes it a singleton and remains the same in the p.list
