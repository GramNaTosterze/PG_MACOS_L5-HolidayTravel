import Foundation


// test data
let cityNames = ["New York", "London", "Paris", "Tokyo", "Sydney", "Rome", "Berlin", "Moscow", "Beijing", "Cairo", "Dubai", "Toronto", "Mumbai", "Los Angeles", "Rio de Janeiro", "Amsterdam", "Barcelona", "Bangkok", "Singapore", "Stockholm"]
let cityDescriptions = ["A bustling metropolis with iconic landmarks.", "A vibrant city known for its rich history and culture.", "A romantic destination famous for its art and cuisine.", "A modern city with a unique blend of tradition and technology.", "A picturesque coastal city with stunning beaches.", "A city steeped in ancient history and architectural wonders.", "A cosmopolitan capital known for its thriving arts scene.", "A vibrant city with a mix of historical and contemporary attractions.", "A bustling metropolis with a rich cultural heritage.", "A vibrant city with a blend of ancient traditions and modern developments.", "A dynamic city known for its luxurious amenities and breathtaking architecture.", "A diverse and multicultural city with a thriving music and arts scene.", "A bustling city with a fast-paced lifestyle and iconic landmarks.", "A vibrant city known for its Bollywood film industry and historical sites.", "A sprawling city with a mix of cultures and entertainment options.", "A lively city known for its festive atmosphere and breathtaking landscapes.", "A charming city famous for its art, architecture, and canals.", "A vibrant city with a rich history and a bustling nightlife.", "A bustling city known for its vibrant street life and delectable cuisine.", "A modern city with a harmonious blend of nature and urban development."]
let tags = ["technology", "travel", "food", "music", "sports", "fashion", "art", "photography", "nature", "fitness", "books", "movies", "gaming", "history", "science", "business", "health", "cooking", "animals", "adventure"]


// clases
class City: CustomStringConvertible {
  static var _id: Int = 0
  struct Point: CustomStringConvertible {
    var x: Double
    var y: Double
    var description: String {
      return "(\(x), \(y))"
    }
  }
  
  var id: Int
  var name: String
  var cityDescription: String
  var latitude: Point
  var tags: Set<String>
  var description: String {
      return "\(id) \(name): \(cityDescription)\n latitude: \(latitude)\n tags: \(tags)"
  }
  
  init(name: String, description: String, x: Double, y: Double, tags: Set<String> = Set<String>() ) {
      self.id = City._id
      City._id += 1
      self.name = name
      self.cityDescription = description
      self.latitude = Point(x: x, y: y)
      self.tags = tags
  }
  
  func distance(city: City) -> Double {
    return distance(cords: city.latitude)
  }
  
  func distance(cords: Point) -> Double{
    let x = self.latitude.x - cords.x
    let y = self.latitude.y - cords.y
    return sqrt(x*x + y*y)
  }
}

class ExtendedCity: City {
  struct Location: Hashable {
    static var _id: Int = 0
    enum LocationType {
      case Restaurant, Pub, Museum,Monument
    }
    
    var id: Int
    var type: LocationType
    var name: String
    var rating: Int
    var hashValue: Int {
      return id.hashValue + name.hashValue + rating.hashValue + type.hashValue
    }
    
    init(type: LocationType, name: String, rating: Int) {
      self.id = Location._id
      Location._id += 1
      self.type = type
      self.name = name
      self.rating = rating%5 + 1
    }
    
  }
  
  var locations: Set<Location>
  
  init(name: String, description: String, x: Double, y: Double, tags: Set<String> = Set<String>(), locations: Set<Location>) {
    self.locations = locations
    super.init(name: name, description: description, x: x, y: y, tags: tags)
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
        if city1.distance(city: city2) > farthest[0].distance(city: farthest[1]) {
          farthest = [city1, city2]
        }
      }
    }
    print("farthest cities: \n\(farthest[0])\n\(farthest[1])")
  }

  // ExtendedCity functions
  func search5Star() -> [City] {
    // TODO
    return []
  }
  func locationsFrom(city: City) -> [ExtendedCity.Location] {
    // TODO
    return []
  }
  func displayCitiesWithLocationInfo() {
    // TPDP
  }
}


// create cities
var cities: [City] = []
for i in 0..<20 {
    let city = City(name: cityNames[i%10], description: cityDescriptions[i], x: Double.random(in: -90.0...90.0), y: Double.random(in: -90.0...90.0) )
    cities.append(city)
}


// main
cities.distance(x: 10, y: 10)
cities.distanceFarthest()