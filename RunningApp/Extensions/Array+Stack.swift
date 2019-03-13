import Foundation

//MARK: - LIFO Array

extension Array {
    
    mutating func push(_ newElement: Element) {
        self.append(newElement)
    }
    
    func peek() -> Element? {
        return self.last
    }
    
}
