//
// Quiz 2
// Name: Divanshu Chauhan
// Date: 09/18/2024
//

import Foundation

// MARK: - 1. Variable and Constant Declarations

// 1a) Declare an optional variable that stores the age of a person
var personAge: Int? = 25  // You can set this to nil or any integer value

// 1b) Declare a constant that stores the earth gravity 9.8
let earthGravity: Double = 9.8

// MARK: - 2. Switch-Case Statement for RFM Indicator

func RMFIndicator(rfm: Double) {
    switch rfm {
    case 0...20:
        print("You are Underfat")
    case 20.01...35:
        print("You are Healthy")
    case 35.01...42:
        print("You are Overfat")
    case 42.01...:
        print("You are Obese")
    default:
        print("Invalid RFM value")
    }
}

// MARK: - 3. String Reversal

// 3a) For loop to display a string in reverse order without using the reverse method
func reverseStr(_ inp: String) -> String {
    var stringReversed = ""
    var i = 0
    while i < inp.count {
        let character = inp[inp.index(inp.startIndex, offsetBy: i)]
        stringReversed = "\(character)" + stringReversed
        i = i + 1
    }
    return stringReversed
}

// 3b) Reverse each word in a string without using the reverse method
func reverseEachWord(in str: String) -> String {
    let words = str.components(separatedBy: " ")
    var rString = ""

    var i = 0
    while i < words.count {
        let word = words[i]
        var rWord = ""
        var charIndex = 0
        while charIndex < word.count {
            let character = word[word.index(word.startIndex, offsetBy: charIndex)]
            rWord = "\(character)" + rWord
            charIndex += 1
        }
        rString += rWord + " "
        i += 1
    }

    return rString.trimmingCharacters(in: .whitespaces)
}

// MARK: - 4. Methods

// 4(part1)) Method to sum positive odd and even numbers in an integer array
func sumPositiveOddAndEven(numbers: [Int]) -> (sumOdd: Int, sumEven: Int) {
    var sumOdd = 0, sumEven = 0

    var i = 0
    while i < numbers.count {
        let number = numbers[i]
        if number > 0 {
            if number % 2 == 0 {
                sumEven += number
                continue
            }
            sumOdd += number
        }
        i += 1
    }

    return (sumOdd, sumEven)
}

// 4(part2)) Method to find the length of the shortest and longest strings in a string array
func findShortestAndLongestLengths(strList: [String]) -> (shortest: Int, longest: Int)? {
    guard !strList.isEmpty else {
        return nil
    }

    var shortest = strList[0].count, longest = strList[0].count

    var i = 0
    while i < strList.count {
        let string = strList[i]
        if string.count < shortest {
            shortest = string.count
        }
        if string.count > longest {
            longest = string.count
        }
        i += 1
    }

    return (shortest, longest)
}

// 4(part3)) Sequential search method in an integer array
func sequentialSearch(arr: [Int], j: Int) -> Bool {
    var i = 0
    while i < arr.count {
        if arr[i] == j {
            return true
        }
        i += 1
    }
    return false
}

// MARK: - Task 5: Object - CityStatistics

class CityStatistics {
    let name: String
    let ppln: Int
    let long: Double
    let lat: Double

    init(name: String, ppln: Int, long: Double, lat: Double) {
        self.name = name
        self.ppln = ppln
        self.long = long
        self.lat = lat
    }

    /// Returns the population of the city.
    func getPopulation() -> Int {
        return ppln
    }

    /// Returns the latitude of the city.
    func getLatitude() -> Double {
        return lat
    }

    /// Returns the latitude of the city.
    func getLongitude() -> Double {
        return long
    }
}

// MARK: - Task 6: Dictionary Data Structure

// 6a) Declare a dictionary with city names as keys and CityStatistics objects as values
var cityDictionary: [String: CityStatistics] = [
    "Paris": CityStatistics(
        name: "Paris", ppln: 2_148_000, long: 2.3522, lat: 48.8566),
    "Delhi": CityStatistics(
        name: "Delhi", ppln: 129_459_000, long: 134.6677, lat: 32.1535),
    "Sydney": CityStatistics(
        name: "Sydney", ppln: 5_312_000, long: 151.2093, lat: -33.8688),
    "Cairo": CityStatistics(
        name: "Cairo", ppln: 20_076_000, long: 31.2357, lat: 30.0444),
    "Moscow": CityStatistics(
        name: "Moscow", ppln: 12_506_000, long: 37.6173, lat: 55.7558),
]

// 6b) Determine and display the city with the largest population
func cityWithLargestPopulationUsingKeys(from dictionary: [String: CityStatistics]) {
    var bigCity: String? = nil
    var bigPeople: Int = 0

    var itr = dictionary.makeIterator()
    while let (name, stat) = itr.next() {
        if stat.getPopulation() > bigPeople {
            bigPeople = stat.getPopulation()
            bigCity = name
        }
    }

    if let largestCity = bigCity {
        print("\nCity with Largest Population: \(largestCity) with population \(bigPeople)")
    } else {
        print("\nNo cities in the dictionary.")
    }
}

// 6c) Determine and display the northernmost city
func northernmostCityUsingKeys(from dictionary: [String: CityStatistics]) {
    var mostNorthCity: String?, highLat: Double = -Double.infinity

    var itr = dictionary.makeIterator()
    while let (name, cityStats) = itr.next() {
        if cityStats.getLatitude() > highLat {
            highLat = cityStats.getLatitude()
            mostNorthCity = name
        }
    }

    if let northernmostCity = mostNorthCity {
        print("\nNorthernmost City: \(northernmostCity) with latitude \(highLat)")
    } else {
        print("\nNo cities in the dictionary.")
    }
}

// MARK: - 7. Finding Student with Highest GPA

var students: [[String: Any]] = [
    ["firstName": "John", "lastName": "Wilson", "gpa": 2.4],
    ["firstName": "Nancy", "lastName": "Smith", "gpa": 3.5],
    ["firstName": "Michael", "lastName": "Liu", "gpa": 3.1],
]

func studentWithHighestGPA(from students: [[String: Any]]) {
    var bestStudent: [String: Any]? = nil, bestGPA: Double = -Double.infinity

    var i = 0
    while i < students.count {
        let student = students[i]
        if let gpa = student["gpa"] as? Double {
            if gpa > bestGPA {
                bestGPA = gpa
                bestStudent = student
                if student["firstName"] as? String != nil,
                    student["lastName"] as? String != nil
                {
                } else {
                    print("Top Student's Name Missing or Incorrectly Typed.")
                }
            }
        } else {
            print("GPA Missing or Incorrectly Typed.")
        }
        i += 1
    }

    if let top = bestStudent,
        let firstName = top["firstName"] as? String,
        let lastName = top["lastName"] as? String
    {
        print("\nFinal Top Student: \(firstName) \(lastName) with GPA: \(bestGPA)")
    } else {
        print("\nNo valid students found.")
    }
}
