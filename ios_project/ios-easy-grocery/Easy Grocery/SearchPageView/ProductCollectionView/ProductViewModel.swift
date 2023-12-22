import UIKit

// 'Название', 'О товаре', 'Производитель', 'Торговая марка', 'Страна', 'Вес', 'Объем', 'Состав', 'Вид', 'Энергетическая ценность', 'Белки', 'Жиры', 'Углеводы', 'Срок годности', 'Стоимость', 'IMG URL', 'URL'

final class ProductViewModel: Codable, Equatable {
    static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        let leftURL = lhs.productURL ?? URL(string: "")
        let rightURL = rhs.productURL ?? URL(string: "")
        return leftURL == rightURL
    }
    
    let name: String
    let description: String?
    let manufacturer: String?
    let trademark: String?
    let country: String?
    let weight: String?
    let volume: String?
    let contents: String?
    let productType: String?
    let kcal: String?
    let protein: String?
    let fats: String?
    let carbohydrates: String?
    let expiresIn: String?
    let price: String?
    let imageURL: URL?
    let productURL: URL?
    
    var imageData: Data? = nil
    
    init(_ name: String, _ description: String? = nil, manufacturer: String? = nil, trademark: String? = nil, country: String? = nil, weight: String? = nil, volume: String? = nil, contents: String? = nil, productType: String? = nil, kcal: String? = nil, protein: String? = nil, fats: String? = nil, carbohydrates: String? = nil, expiresIn: String? = nil, price: String? = nil, imageURL: URL? = nil, productURL: URL? = nil, imageData: Data? = nil) {
        self.name = name
        self.description = description
        self.manufacturer = manufacturer
        self.trademark = trademark
        self.country = country
        self.weight = weight
        self.volume = volume
        self.contents = contents
        self.productType = productType
        self.kcal = kcal
        self.protein = protein
        self.fats = fats
        self.carbohydrates = carbohydrates
        self.expiresIn = expiresIn
        self.price = price
        self.imageURL = imageURL
        self.productURL = productURL
        self.imageData = imageData
    }
}
