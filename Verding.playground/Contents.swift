


protocol VendingMachine {
    var name: String {get}
    var startMoney: Int {get set}
    func buySneck(name: String, count: Int) throws
    func sendMoney(money: Int)
    init(name: String) throws
}

enum VendingMachineError: Error {
    case noInitMachine
    case moneyLow(enterMoney: Int)
    case noCount(count: Int)
    case invalidMoney
    case noProductInSelect
}

struct Sneck {
    var name: String
    var price: Int
    var count: Int
}

class Vending: VendingMachine {

    var name: String
    
    var startMoney: Int = 0
    
    func buySneck(name: String, count: Int) throws {
        let startProduct = [
            "Coca-Cola" : Sneck(name: "Coca-Cola", price: 53, count: 45),
            "Fanta" : Sneck(name: "Fanta", price: 45, count: 20)]
        
        guard let item = startProduct[name] else {
            throw VendingMachineError.noProductInSelect
        }
        
        guard item.price * count < startMoney else {
            throw VendingMachineError.moneyLow(enterMoney: item.price * count - startMoney)
        }
        
        guard item.count >= count else {
            throw VendingMachineError.noCount(count: item.count)
        }
        
        var newItem = item
        print("Купили \(newItem.name), в кол-ве \(newItem.count) за \(newItem.price * newItem.count)")
        newItem.count -= count
        
        
    }
    
    func sendMoney(money: Int) {
        self.startMoney = money
    }
    
    required init(name: String) throws {
        guard name != "" else {
            throw VendingMachineError.noInitMachine
        }
        self.name = name
    }
    
    
}

do {
    _ = try Vending(name: "")
} catch VendingMachineError.noInitMachine {
    print("Вы не назвали машину")
}


do {
    let newMachine2 = try Vending(name: "Аппарат газировки")
    print("Создали новую машину для продажи снеков")
    newMachine2.sendMoney(money: 5000000)
    try newMachine2.buySneck(name: "Coca-Cola", count: 45)
    try newMachine2.buySneck(name: "Fanta", count: 20)
} catch VendingMachineError.noProductInSelect {
    print("Нет такого продукта")
} catch VendingMachineError.moneyLow(let money) {
    print("Не хватает \(money) баблишка, докинь")
} catch VendingMachineError.noCount(let count) {
    print("Нет такого кол-ва, осталось всего - \(count)")
}
