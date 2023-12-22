import UIKit

class ParsingHelper {
    static func parseJSONFile(filename: String) -> [CheckboxCell]? {
        // Get the path to the JSON file
        guard let path = Bundle.main.path(forResource: filename, ofType: "JSON") else {
            return nil
        }
        
        do {
            // Read the contents of the file
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            // Decode the JSON data into an array of CheckboxCell objects
            let decoder = JSONDecoder()
            let cells = try decoder.decode([CheckboxCell].self, from: data)
            
            return cells
        } catch {
            print("Error decoding JSON file: \(error)")
            return nil
        }
    }
    
    static func loadSavedJSONFile(filename: String) -> [CheckboxCell]? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        do {
            let path = documentsDirectory.appendingPathComponent(filename + ".JSON")
            if let data = try? Data(contentsOf: path) {
                let decoder = JSONDecoder()
                let cells = try decoder.decode([CheckboxCell].self, from: data)
                return cells
            }
        } catch {
            print("Error decoding JSON file: \(error)")
            return nil
        }
        
        return nil
    }
    
    static func saveJSONFile(filename: String, items: [CheckboxCell]) {
        let encoder = JSONEncoder()
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        do {
            let data = try encoder.encode(items)
            
            let path = documentsDirectory.appendingPathComponent(filename + ".JSON")
            print(path)
            try data.write(to: path)
        } catch {
            print("Error writing JSON file: \(error)")
            return
        }
    }
    
    static func getProductsCSV() -> [ProductViewModel] {
        var products = [ProductViewModel]()
        
        guard let filepath = Bundle.main.path(forResource: "vprok_base", ofType: "csv") else {
            return products
        }
        
        var data = ""
        do {
            data = try String(contentsOfFile: filepath)
        } catch {
            print(error)
            return products
        }
        
        var rows = data.components(separatedBy: "\n")
        rows.removeFirst()
        
        // 0index, 1'Название', 2'О товаре', 3'Производитель', 4'Торговая марка', 5'Страна', 6'Вес', 7'Объем', 8'Состав', 9'Вид', 10'Энергетическая ценность', 11'Белки', 12'Жиры', 13'Углеводы', 14'Срок годности', 15'Стоимость', 16'IMG URL', 17'URL'
        for row in rows {
            let columns = row.components(separatedBy: "|")
            if columns.count < 18 {
                continue
            }
            let productName = columns[1]
            let description = columns[2].count != 0 ? columns[2] : nil
            let manufacturer = columns[3].count != 0 ? columns[3] : nil
            let trademark = columns[4].count != 0 ? columns[4] : nil
            let country = columns[5].count != 0 ? columns[5] : nil
            let weight = columns[6].count != 0 ? columns[6] : nil
            let volume = columns[7].count != 0 ? columns[7] : nil
            let contents = columns[8].count != 0 ? columns[8] : nil
            let productType = columns[9].count != 0 ? columns[9] : nil
            let kcal = columns[10].count != 0 ? columns[10] : nil
            let protein = columns[11].count != 0 ? columns[11] : nil
            let fats = columns[12].count != 0 ? columns[12] : nil
            let carbohydrates = columns[13].count != 0 ? columns[13] : nil
            let expiresIn = columns[14].count != 0 ? columns[14] : nil
            let price = columns[15].count != 0 ? columns[15] : nil
            let imageURL = columns[16]
            let productURL = columns[17]
            
            let product = ProductViewModel(productName, description, manufacturer: manufacturer, trademark: trademark, country: country, weight: weight, volume: volume, contents: contents, productType: productType, kcal: kcal, protein: protein, fats: fats, carbohydrates: carbohydrates, expiresIn: expiresIn, price: price, imageURL: URL(string: imageURL), productURL: URL(string: productURL))
            
            products.append(product)
        }
        
        return products
    }
    
    static func getExcludePreferences() -> [String] {
        // Load the plist file
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let plistPath = documentsDirectory.appendingPathComponent("UserPreferences.plist")
            if let plistData = try? Data(contentsOf: plistPath) {
                if let preferences = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] {
                    return preferences["exclude_items"] as! [String]
                }
            }
        }
        
        return []
    }
    
    static func setExcludePreferences(_ excludeList: [String]) {
        // Load the plist file
        print("Set preferences invoked")
        if let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("UserPreferences.plist") {
            print(plistURL)
            let dict = ["exclude_items": excludeList]
            let data = try! PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
            try! data.write(to: plistURL)
        }
    }
    
    static func shouldExcludeProductByItem(excludedItem: String, product: ProductViewModel) -> Bool {
        let description = product.description ?? ""
        let contents = product.contents ?? ""
        let productType = product.productType ?? ""
        let name = product.name
        for text in [description, contents, productType, name] {
            if text.lowercased().contains(excludedItem.lowercased()) {
                return true
            }
        }
        
        return false
    }
    
    static func checkBarcode(_ barcode: String, completion: @escaping (ProductViewModel) -> Void) {
        var result = ["title": "", "description": "", "keywords": ""]
        let regexps = [
            "title": "(?<=<title>).*?(?=</title>)",
            "description": "(?<=<meta name=\"description\" content=\").*?(?=>)",
            "keywords": "(?<=<meta name=\"Keywords\" content=\").*?(?=>)"
        ]
        
        if let url = URL(string: "https://barcode-list.ru/barcode/RU/%D0%9F%D0%BE%D0%B8%D1%81%D0%BA.htm?barcode=" + barcode) {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("Error: No data returned")
                    return
                }

                if let htmlString = String(data: data, encoding: .utf8) {
                    for key in regexps.keys {
                        if let pattern = regexps[key] {
                            let regex = try! NSRegularExpression(pattern: pattern, options: [])
                            let range = NSRange(location: 0, length: htmlString.utf16.count)
                            let match = regex.firstMatch(in: htmlString, options: [], range: range)
                            if let matchRange = Range(match!.range, in: htmlString) {
                                let matchString = htmlString[matchRange]
                                result[key] = String(matchString)
                            }
                        }
                    }
                    
                    let title = result["title"]?.replacingOccurrences(of: " - " + "Штрих-код: " + barcode, with: "")
                    var description = result["description"]?.components(separatedBy: ";")[0]
                    description = description?.replacingOccurrences(of: "Штрих-код:" + barcode + " - ", with: "")
                    let contents = result["keywords"]?.replacingOccurrences(of: "\"", with: "")
                    
                    completion(ProductViewModel(title ?? "", description, contents: contents))
                }
            }

            task.resume()
        }
    }
}
