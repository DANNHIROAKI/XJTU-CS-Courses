import Foundation

let PAGES = 10
let REFERENCE_LENGTH = 20

func generateReferenceString() -> [Int] {
    var reference = [Int]()
    for _ in 0..<REFERENCE_LENGTH {
        reference.append(Int(arc4random_uniform(UInt32(PAGES))))
    }
    return reference
}

func fifo(reference: [Int], frames: Int) -> Int {
    var pageFaults = 0
    var s = Set<Int>()
    var indexes = [Int]()

    for ref in reference {
        if !s.contains(ref) {
            if s.count == frames {
                let firstIn = indexes.removeFirst()
                s.remove(firstIn)
            }
            s.insert(ref)
            indexes.append(ref)
            pageFaults += 1
        }
    }
    return pageFaults
}

func lru(reference: [Int], frames: Int) -> Int {
    var pageFaults = 0
    var s = Set<Int>()
    var indexes = [Int: Int]()

    for i in 0..<reference.count {
        let ref = reference[i]
        if !s.contains(ref) {
            if s.count == frames {
                var lruPage = -1, lruIdx = Int.max
                for page in s {
                    if let idx = indexes[page], idx < lruIdx {
                        lruIdx = idx
                        lruPage = page
                    }
                }
                s.remove(lruPage)
            }
            s.insert(ref)
            pageFaults += 1
        }
        indexes[ref] = i
    }
    return pageFaults
}

func opt(reference: [Int], frames: Int) -> Int {
    var pageFaults = 0
    var s = Set<Int>()
    var nextUse = [Int: Int]()

    for i in 0..<reference.count {
        let ref = reference[i]
        if !s.contains(ref) {
            if s.count == frames {
                var farthestIdx = -1, replacePage = -1
                for page in s {
                    if nextUse[page] == nil {
                        replacePage = page
                        break
                    } else if let idx = nextUse[page], idx > farthestIdx {
                        farthestIdx = idx
                        replacePage = page
                    }
                }
                s.remove(replacePage)
            }
            s.insert(ref)
            pageFaults += 1
        }
        nextUse[ref] = nil
        for j in (i + 1)..<reference.count {
            if reference[j] == ref {
                nextUse[ref] = j
                break
            }
        }
    }
    return pageFaults
}

let reference = generateReferenceString()
print("Generated Reference String: \(reference)")

for frames in 1...7 {
    print("\nFor \(frames) frames:")
    print("FIFO: \(fifo(reference: reference, frames: frames)) page faults.")
    print("LRU : \(lru(reference: reference, frames: frames)) page faults.")
    print("OPT : \(opt(reference: reference, frames: frames)) page faults.")
}
