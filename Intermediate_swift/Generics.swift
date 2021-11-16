//
//  Generics.swift
//  Intermediate_swift
//
//  Created by Vasileios  Gkreen on 16/11/21.
//

import Foundation


/*
 When using generics, Swift (when compiling) will transform a generic function into multiple
 functions that have a specific type. This depends on how we call this function. For example
 calling a count() with Int as parameter and then calling it again with Double as aprameter
 will result in two different functions. This is called "Function Specialization"
 */


// MARK: Simple generic
/*
	A very simple struct with generic type T that accepts any kind of values as long as they are of the same type
*/
struct Pair<T> {
	var start: T
	var end: T
}



// MARK: Simple generic with constraint
/*
 A Simple function that take a generic type T as parameter
 and this parameter is contraint to be a Numeric value
 */
func count<T: Numeric>(numbers: [T]) -> T {
	let total = numbers.reduce(0, +)
	return total
}



// MARK: Static Dispatch

/*
	Static dispatch is when Swift already knows the type of a function or a parameter
	on runtime (and it doesn't need to go and look for it) because we used generics
	and it's already fifured out the type on compile time.
*/

protocol Prioritized {
	var priority: Int { get }
	func alertIfImportant()
}


struct Work: Prioritized {
	let priority: Int
	
	func alertIfImportant() {
		if priority > 3 {
			print("Important work alert!")
		}
	}
}


struct Document: Prioritized {
	var priority: Int
	
	func alertIfImportant() {
		if priority > 5 {
			print("Important document alert!")
		}
	}
}

/*
	Swift will figure out the types of P (can be comming from Work or Document structs)
	on compile time. It will also use the exact code that is needed to determine if something is important
	resulting in the minimization of code that is needed to run this function. For example:
 
	THIS -> item.alertIfImportant() -> will "become" this -> if priority > 5 { print("Important document alert!") }
	OR THIS -> if priority > 3 { print("Important work alert!") } depending on the call site of the function
 
*/
func checkProirity<P: Prioritized>(of item: P) {
	print("Checking priority ...")
	item.alertIfImportant()
}





// MARK: Recreate a type (NSCountedSet)

struct countedSet<T: Hashable>: Equatable, Hashable {
	private var elements = [T : Int]()
	private var count: Int { elements.count }
	private var isEmpty: Bool { elements.isEmpty }
	
	mutating func insert(_ element: T) {
		elements[element, default: 0] += 1
	}
	
	mutating func remove(_ element: T) {
		elements[element, default: 0] -= 1
	}
	
	func count(for element: T) -> Int {
		elements[element, default: 0]
	}
}

/*
 var scores = countedSet<Int>()
 scores.insert(1)
 scores.insert(1)
 scores.insert(2)
 scores.count(for: 1) // log 2
 scores.count(for: 2) // log 1
*/

/*
 var names = countedSet<String>()
 scores.insert("Bob")
 scores.insert("Pep")
 scores.insert("Pep")
 scores.count(for: "Bob") // log 1
 scores.count(for: "Pep") // log 2
*/


// MARK: Extend types

/*
 
 var array = [1, 2, 1, 3, 1, 4, 5]
 array.removeAll(where: {$0 == 1} )
 
 The above example mutates the array. We can build an extension that actually copies the array befor mutating it
 */

extension Array where Element: Equatable {
	mutating func removing(_ obj: Element) -> [Element] {
		filter { $0 != obj }
	}
}



struct Teacher: Equatable {
	var name: String
}
struct Student: Equatable {
	var name: String
}
let student1 = Student(name: "mike")
let student2 = Student(name: "Maria")
let student3 = Student(name: "bobo")

var array: [Student] = [student3, student1, student1, student2, student1]
let noOnes = array.removing(Student.init(name: "mike"))




extension Sequence {
	func uniqueElements<T: Hashable>(byProperty propertyAccessor: (Element) -> T) -> [Element] {
		var seen = Set<T>()
		var result = [Element]()
		
		// go over each item in the array
		for element in self {
			// call the passed closure to read the name of all the elements (in this case is name, can be anything)
			let property = propertyAccessor(element)
			
			// if its not seen before add it as seen and add it to the returnin array (result)
			if seen.contains(property) == false {
				result.append(element)
				seen.insert(property)
			}
		}
		
		return result
	}
}


let uniqueStudents = array.uniqueElements { student in
	return student.name
}


// MARK: Generics in Propery Wrappers

struct SpeedTracker {
	@NonNegative var current = 0.0
	@NonNegative var highest = 0.0
}


@propertyWrapper struct NonNegative<T: SignedNumeric & Comparable> {
	var value: T
	
	init(wrappedValue: T) {
		self.value = max(0, wrappedValue) // ensure that the number will not go bellow 0
	}
	
	var wrappedValue: T {
		get { value }
		set { value = max(0, newValue) } // ensure that the number will not go bellow 0
	}
}
