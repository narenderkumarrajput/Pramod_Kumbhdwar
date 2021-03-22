extension String {
    var maxOccuredCharAndCount: (String, Int) {
        if !isEmpty {
            var maxCount = 0
            var maxOccurringCharacter: String = ""
            let uniqueChar = Set(self)
            for char in uniqueChar {
                let count = repeatCountOf(letter: String(char))
                if maxCount < count {
                    maxCount = count
                    maxOccurringCharacter = String(char)
                }
            }
            return (maxOccurringCharacter, maxCount)
        } else {
            return ("", 0)
        }
    }

    func repeatCountOf(letter alphabet: String) -> Int {
        var occurance = 0
        for character in self {
            let value = String(character)
            if value == alphabet {
                occurance += 1
            }
        }
        return occurance
    }

    func validateForMaxAdjacentCharacter(maxCount: Int) -> Bool {
        
        return true
    }

    func validateForMaxAdjacentNumberSequence(maxCount: Int) -> Bool {
        
        return true
    }
}
