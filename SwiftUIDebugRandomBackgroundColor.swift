//
//  SwiftUIDebugRandomBackgroundColor.swift
//  SwiftUIDebugRandomBackgroundColor
//
//  Created by acevif (acevif@gmail.com) on 2023-03-26.
//

import SwiftUI

#if DEBUG
    fileprivate let debugBackgroundColors = [
        Color.red,
        Color.orange,
        Color.yellow,
        Color.green,
        Color.cyan,
        Color.blue,
        Color.indigo,
        Color.purple,
        Color.gray,
    ]

    fileprivate let baseRandomSeed: Int = 3_276_482_673_742_026_387

    public extension View {
        /// A modifier to set random background color to debug SwiftUI's View.
        /// Random background colors are equal across different executions of your program.
        /// To change background color, set some new random integer to `additionalRandomSeed`
        func debugRandomBackgroundColor(
            additionalRandomSeed: Int = 1_234_567_890,
            filenameAsRandomSeed: String = #file,
            lineNumberAsRandomSeed: Int = #line,
            columnNumberAsRandomSeed: Int = #column,
            functionNameAsRandomSeed: String = #function
        ) -> some View {
            var hasher = DeterministicHasher()
            baseRandomSeed.hash(into: &hasher)
            filenameAsRandomSeed.hash(into: &hasher)
            lineNumberAsRandomSeed.hash(into: &hasher)
            columnNumberAsRandomSeed.hash(into: &hasher)
            functionNameAsRandomSeed.hash(into: &hasher)
            additionalRandomSeed.hash(into: &hasher)

            let hash: Int = hasher.finalize()

            let randomIndex = ((hash % debugBackgroundColors.count) + debugBackgroundColors.count) % debugBackgroundColors.count
            assert(randomIndex >= 0 && randomIndex < debugBackgroundColors.count)
            let randomColor = debugBackgroundColors[randomIndex]

            return background(randomColor)
        }
    }

    // djb2 hash function (xor version)
    // hash(i) = hash(i - 1) * 33 ^ str[i]
    struct DeterministicHasher {
        private var hash: Int! = 5381 // maybe djb2 magic number

        mutating func combine(values: [Int]) {
            hash = values
                .reduce(hash) { hash, value in
                    ((hash << 5) &+ hash) ^ value
                }
        }

        mutating func finalize() -> Int {
            guard let hash else {
                fatalError()
            }

            defer { self.hash = nil }

            return hash
        }
    }

    protocol DeterministicHashable {
        func hash(into hasher: inout DeterministicHasher)
    }

    extension Int: DeterministicHashable {
        func hash(into hasher: inout DeterministicHasher) {
            hasher.combine(values: [self])
        }
    }

    extension String: DeterministicHashable {
        func hash(into hasher: inout DeterministicHasher) {
            hasher.combine(values: unicodeScalars.map { Int($0.value) })
        }
    }

#endif
