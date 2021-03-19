// slight protocol tangent
protocol NamedThing {
    var name: String { get set }

    func printHello()
}

func makeNamedThingSpeak(_ thing: NamedThing) {
    thing.printHello()
}

struct Pet: NamedThing {
    var name: String

    func printHello() {
        print("[pet noise] I'm \(name)")
    }
}

let pet = Pet(name: "Jangle") // that's Matt's dog!
makeNamedThingSpeak(pet)

// Function Programming below!
struct Person: NamedThing {
    var name: String

    func printHello() {
        print("Hello my name is \(name)")
    }

    /// Prints hello to the provided person
    /// - Parameter otherPerson: A `Person` to say hello to
    func printHello(to otherPerson: Person) {
        print("Hello \(otherPerson.name), my name is \(name)")
    }

    func hello() -> String {
        return "Hello my name is \(name)"
    }

    func hello(to otherPerson: Person) -> String {
        return "Hello \(otherPerson.name), my name is \(name)"
    }
}

let zev = Person(name: "Zev")
let matt = Person(name: "Matt")

zev.printHello()
zev.printHello(to: matt)
matt.printHello(to: zev)

zev.hello()
matt.hello(to: zev)

print("--------------- Map --------------")

let people = [zev, matt] // let people: [Person] = [zev, matt] (this is the same)

for person in people {
    person.printHello()
}

var helloStrings = [String]() // var helloStrings: [String] = [] (this is the same)

for person in people {
    let str = person.hello()
    helloStrings.append(str)
}

print(helloStrings)

let helloStringsMapped = people.map { (person) -> String in
    return person.hello()
}

// let's rebuild map (for entertainment purposes... you wouldn't necessarily want to do this)
extension Sequence {
    // (Person) -> T this is our closure (basically a function (but not really))
    // T is a generic (we renamed it to `Transformed`) we don't know its type until it's used

    func myMap<Transformed>(_ transform: (Element) -> Transformed) -> [Transformed] {
        var output = [Transformed]()

        for element in self {
            let transformed = transform(element)
            output.append(transformed)
        }

        return output
    }
}

people.myMap { (person) -> String in
    return person.hello()
}

print("--------------- Filter --------------")

let numbers = 0...100

var multiplesOfThree: [Int] = []

// number % 3 == 0      the % is called modulo and more confusing than `isMultiple(of:)`. it calculates remainders
for number in numbers {
    if number.isMultiple(of: 3){
        multiplesOfThree.append(number)
    }
}

print(multiplesOfThree)

let multiplesOfThreeFiltered = numbers.filter { (number) -> Bool in
    return number.isMultiple(of: 3)
}


print("--------------- Shorthand --------------")
// this is the longest form of our simplest higher order function
let namesLongClosure = people.map({ (person: Person) -> String in
    return person.name
})

// trailing closure (no parenthesis around the closure)
let names_2 = people.map { (person: Person) -> String in
    return person.name
}

let names_3 = people.map { (person) -> String in
    return person.name
}

let names_4 = people.map { person -> String in
    return person.name
}

let names_5 = people.map { person  in
    return person.name
}

let names_6 = people.map { person in
    person.name
}

let names_7 = people.map {
    $0.name
}

// this is the not smallest we can do
let names_8 = people.map { $0.name }

// we've reached the smallest possible level
let names_9 = people.map(\.name)


print("--------------- Passing Closures --------------")

func isMultipleOfFive(_ num: Int) -> Bool {
    return num.isMultiple(of: 5)
}

let fives = numbers.filter(isMultipleOfFive(_:))
print(fives)

let isMultipleOfTen: (Int) -> Bool = { num in
    return num.isMultiple(of: 10)
}

let closureBasedTens = numbers.filter(isMultipleOfTen)

// functional programming can get heady. this is a function that takes an integer and returns a closure. it can get headier
func makeFunctionToCheckIfIsMultiple(of divisor: Int) -> ((Int) -> Bool) {
    return { int in
        return int.isMultiple(of: divisor)
    }
}
// you can make a closure that takes a closure and returns a different closure. google that if you'd like.
// you can also research currying
// both aren't necessary to leverage functional programming practices in your codebase

let isMultipleOfFour = makeFunctionToCheckIfIsMultiple(of: 4)

let fours = numbers.filter(isMultipleOfFour)
print(fours)


print("--------------- Chaining --------------")

let evenMultiplesOfThree = numbers
    .filter { $0.isMultiple(of: 3) }
    .filter { $0.isMultiple(of: 2) }

print(evenMultiplesOfThree)

let squareEvenMultiplesOfThree = numbers
    .filter { $0.isMultiple(of: 3) }
    .filter { $0.isMultiple(of: 2) }
    .map { $0 * $0 }
    .sorted(by: >)
    .reversed() // this is more performant than the above (and more readable)
print(squareEvenMultiplesOfThree)


print("--------------- Reduce --------------")
// this is the one that Matt never understands no matter how many times it's explained

// squishes all your values down into a single value using a transformation you provide
// e.g. take an array of numbers and return the sum

let sumOfEvenMultiplesOfThree = evenMultiplesOfThree.reduce(0) { (result, next) -> Int in
    return result + next
}
print(sumOfEvenMultiplesOfThree)

let sumOfEvenMultiplesOfThreeSimplified = evenMultiplesOfThree.reduce(0, +) // this is the one that blows Matt's mind
print(sumOfEvenMultiplesOfThreeSimplified)

let sentence = "Abandon all hope ye you enter here"

let transformedWarning = sentence
    .split(separator: " ")
    .reduce("") { (result, next) -> String in
        return result + "👏" + next
    }
    .dropFirst()
print(transformedWarning)

// another digression
let thisWholeThing = [1, 2, 3, 4, 5][2...]
print(thisWholeThing.indices)
Array(thisWholeThing)[0]
