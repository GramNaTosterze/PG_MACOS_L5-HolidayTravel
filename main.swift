import Foundation


// test data
let cityNames = ["New York", "London", "Paris", "Tokyo", "Sydney", "Rome", "Berlin", "Moscow", "Beijing", "Cairo", "Dubai", "Toronto", "Mumbai", "Los Angeles", "Rio de Janeiro", "Amsterdam", "Barcelona", "Bangkok", "Singapore", "Stockholm"]
let cityDescriptions = ["A bustling metropolis with iconic landmarks.", "A vibrant city known for its rich history and culture.", "A romantic destination famous for its art and cuisine.", "A modern city with a unique blend of tradition and technology.", "A picturesque coastal city with stunning beaches.", "A city steeped in ancient history and architectural wonders.", "A cosmopolitan capital known for its thriving arts scene.", "A vibrant city with a mix of historical and contemporary attractions.", "A bustling metropolis with a rich cultural heritage.", "A vibrant city with a blend of ancient traditions and modern developments.", "A dynamic city known for its luxurious amenities and breathtaking architecture.", "A diverse and multicultural city with a thriving music and arts scene.", "A bustling city with a fast-paced lifestyle and iconic landmarks.", "A vibrant city known for its Bollywood film industry and historical sites.", "A sprawling city with a mix of cultures and entertainment options.", "A lively city known for its festive atmosphere and breathtaking landscapes.", "A charming city famous for its art, architecture, and canals.", "A vibrant city with a rich history and a bustling nightlife.", "A bustling city known for its vibrant street life and delectable cuisine.", "A modern city with a harmonious blend of nature and urban development."]
let tags = ["technology", "travel", "food", "music", "sports", "fashion", "art", "photography", "nature", "fitness", "books", "movies", "gaming", "history", "science", "business", "health", "cooking", "animals", "adventure"]
let locationNames = ["Beachside Resort", "Mountain Retreat", "City Center", "Coastal Paradise", "Rural Getaway", "Historical Landmark", "Tropical Island", "Ski Resort", "Lakefront Retreat", "Urban Oasis", "Desert Escape", "Isolated Sanctuary", "Countryside Cottage", "Seaside Hideaway", "Cosmopolitan Hub", "Enchanting Forest", "Vibrant Downtown", "Quaint Village", "Exotic Jungle", "Peaceful Oasis"]
let locationDescription = ["A stunning resort with breathtaking views of the beach.", "A tranquil retreat nestled in the mountains, perfect for relaxation.", "A bustling center with a vibrant atmosphere and numerous attractions.", "A paradise by the coast offering pristine beaches and crystal-clear waters.", "A peaceful getaway surrounded by the beauty of the countryside.", "A place of historical significance with remarkable architecture and stories.", "A tropical island filled with palm trees, white sand beaches, and turquoise waters.", "A winter wonderland with thrilling slopes and cozy lodges.", "A serene retreat with a picturesque view of a tranquil lake.", "An urban oasis with modern amenities and a touch of nature.", "A desert escape where you can experience the vastness of the sand dunes.", "An isolated sanctuary far away from the hustle and bustle of city life.", "A charming cottage in the countryside, perfect for a peaceful vacation.", "A hidden hideaway by the seaside, offering serenity and natural beauty.", "A cosmopolitan hub with a rich blend of culture, art, and cuisine.", "An enchanting forest with lush greenery and magical ambiance.", "A vibrant downtown area with a lively atmosphere and bustling streets.", "A quaint village with cobblestone streets and charming architecture.", "An exotic jungle filled with diverse wildlife and adventure.", "A peaceful oasis where you can rejuvenate and find inner peace."]
    



// clases
class City: CustomStringConvertible {
  static var _id: Int = 0
  struct Point: CustomStringConvertible {
    var x: Double
    var y: Double
    var description: String { return "(\(x), \(y))" }
  }
  
  var id: Int
  var name: String
  var cityDescription: String
  var latitude: Point
  var tags: Set<String>
  var description: String { return "\(id) \(name): \(cityDescription)\n latitude: \(latitude)\n tags: \(tags)" }
  
  init(name: String, description: String, x: Double, y: Double, tags: Set<String> = Set<String>() ) {
      self.id = City._id
      City._id += 1
      self.name = name
      self.cityDescription = description
      self.latitude = Point(x: x, y: y)
      self.tags = tags
  }
  init(city: City) {
    self.id = city.id
    self.name = city.name
    self.cityDescription = city.cityDescription
    self.latitude = city.latitude
    self.tags = city.tags
  }
  
  func distance(city: City) -> Double { return distance(cords: city.latitude) }
  
  func distance(cords: Point) -> Double{
    let x = self.latitude.x - cords.x
    let y = self.latitude.y - cords.y
    return sqrt(x*x + y*y)
  }
  class func random() -> City {
    return City(name: cityNames[_id % cityNames.count], description: cityDescriptions[_id % cityDescriptions.count], x: Double.random(in: -90.0...90.0), y: Double.random(in: -90.0...90.0), tags: genRandTags() )
  }
}

class ExtendedCity: City {
  struct Location: Hashable, CustomStringConvertible {
    static var _id: Int = 0
    enum LocationType: CustomStringConvertible, CaseIterable {
      case Restaurant, Pub, Museum,Monument
      var description: String {
        switch self {
          case .Restaurant:  return "Restaurant"
          case .Pub:         return "Put"
          case .Museum:      return "Museum"
          case .Monument:    return "Monument"
        }
      }
      static func random() -> LocationType { return self.allCases.randomElement()! }
    }
    
    var id: Int
    var type: LocationType
    var name: String
    var rating: Int
    var description: String { return "\(id) \(name): \(type), rating: \(rating)\n" }
    var hashValue: Int { return id.hashValue }
    
    init(type: LocationType, name: String, rating: Int) {
      self.id = Location._id
      Location._id += 1
      self.type = type
      self.name = name
      self.rating = rating%5 + 1
    }
    static func random() -> Location {
      let randIdx = Int.random(in: 0..<locationNames.count)
      return Location(type: LocationType.random(), name: locationNames[randIdx], rating: Int.random(in: 0...5) )
    }
    static func randomSet() -> Set<Location> {
      var locationSet = Set<Location>()
      let randNumOfLocations = Int.random(in: 1...10)
      for _ in 1...randNumOfLocations {
        let location = Location.random()
        locationSet.insert(location)
      }
      return locationSet
    }
  }
  
  var locations: Set<Location>
  override var description: String { return super.description + "\nLocations: \(locations)" }
  
  init(name: String, description: String, x: Double, y: Double, tags: Set<String> = Set<String>(), locations: Set<Location>) {
    self.locations = locations
    super.init(name: name, description: description, x: x, y: y, tags: tags)
  }
  init(city: City, locations: Set<Location>) {
    self.locations = locations
    super.init(city: city)
  }
  func sortedLocations() -> Set<Location> { return Set<Location>(locations.sorted(by: {$0.rating > $1.rating} )) }
  override class func random() -> ExtendedCity {
    let city = City.random()
    return ExtendedCity(city: city, locations: Location.randomSet())
  }
}


// Extending array of cities with functions from zad2
extension Array where Element: City {

  // City functions
  func search(name: String)  -> [City]{
      var searchedCities: [City] = []
      for city in self {
          if city.name == name {
              searchedCities.append(city)
          }
      }
      return searchedCities
  }
  
  func search(keyword: String) -> [City] {
      var searchedCities: [City] = []
      for city in self {
          if city.tags.contains(keyword) {
              searchedCities.append(city)
          }
      }
      return searchedCities
  }
  
  func distance(x: Double, y: Double) {
    if self.isEmpty {
      print("Array empty")
      return
    }
    var closest: City = self[0]
    var farthest: City = self[0]
    for city in self {
      closest = city.distance(cords: City.Point(x: x, y: y)) < closest.distance(cords: City.Point(x: x, y: y)) ? city : closest
      farthest = city.distance(cords: City.Point(x: x, y: y)) > closest.distance(cords: City.Point(x: x, y: y)) ? city : farthest
    }
    print("closest: \n \(closest) \nfarthest: \n \(farthest)")
  }
  
  func distanceFarthest() {
    if self.count < 2 {
      print("Array too small")
    }
    var farthest: [City] = [self[0], self[1]] 
    for city1 in self {
      for city2 in self {
        if city1.distance(city: city2) > farthest[0].distance(city: farthest[1]) { farthest = [city1, city2] }
      }
    }
    print("farthest cities: \n\(farthest[0])\n\(farthest[1])")
  }

  // ExtendedCity functions
  func search5Star() -> [ExtendedCity] {
    var searchedCities: [ExtendedCity] = []
    for city in self {
      if city is ExtendedCity {
        for location in (city as! ExtendedCity).locations {
          if location.rating == 5 { 
            searchedCities.append(city as! ExtendedCity) 
            break
          }
        }
      }
    }
    return searchedCities
  }
  func locationInfo() {
    let FiveStarLocations = self.search5Star()
    for city in FiveStarLocations {
      let cityInfo: String = "name: \(city.name)"
      var locations: String = ""
      var locationNumber: Int = 0
      for location in city.locations {
        if location.rating == 5 {
          locations += " \(location.name)\n"
          locationNumber += 1
        }
      }
      print(cityInfo + "(\(locationNumber))\n" + locations)
    }
  }
}

func genRandTags() -> Set<String> {
  let numberOfTags = Int.random(in: 1...10)
  var cityTags = Set<String>()
  for _ in 1...numberOfTags {
    let tag = tags.randomElement()!
    cityTags.insert(tag)
  }
  return cityTags
}
// create cities
var cities: [City] = []
for _ in 0..<20 {
  let city = City.random()
  cities.append(city)
}
// add 10 extended cities
for _ in 0..<20 {
  let city = ExtendedCity.random()
  cities.append(city)
}

// main

// ZAD1
print("\n\n    ZAD1")
for i in 0..<20 { print(cities[i]) }

// ZAD2
print("\n\n    ZAD2")
print("  search by name: London")
for city in cities.search(name: "London") { print(city) }
print("\n  search by keyword: technology")
for city in cities.search(keyword: "technology") { print(city) }

// ZAD3
print("\n\n    ZAD3")
print("  distance from point x: 10, y: 10")
cities.distance(x: 10, y: 10)
print("\n  farthest from array")
cities.distanceFarthest()

// ZAD4
print("\n\n    ZAD4")
for i in 20..<40 { print(cities[i]) }

// ZAD5
print("\n\n    ZAD5")
print("  search for cities with 5 star locations")
for city in cities.search5Star() { print(city) }

print("  sorted locations acording to rating")
for location in ExtendedCity.random().sortedLocations() { print(location) }

print("  display 5 star location of cities")
cities.locationInfo()