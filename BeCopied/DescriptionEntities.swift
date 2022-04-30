
import Foundation


struct TechCrunch: Codable{
    var articles: [TechCrunchDescription]
}
struct TechCrunchDescription: Codable{
    var description: String
}


struct Apple: Codable{
    var articles: [AppleDescription]
}
struct AppleDescription: Codable{
    var description: String
}


struct WallStreetJournal: Codable{
    var articles: [WallStreetJournalDescription]
}
struct WallStreetJournalDescription: Codable{
    var description: String
}


struct BusinessInUS: Codable{
    var articles: [BusinessInUSDescription]
}
struct BusinessInUSDescription: Codable{
    var description: String
}


struct Tesla: Codable{
    var articles: [TeslaDescription]
}
struct TeslaDescription: Codable{
    var description: String
}


