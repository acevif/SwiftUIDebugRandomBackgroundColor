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
            let hash: Int = additionalRandomSeed ^
                filenameAsRandomSeed.count ^
                lineNumberAsRandomSeed ^
                columnNumberAsRandomSeed ^
                functionNameAsRandomSeed.count ^
                baseRandomSeed

            let randomIndex = ((hash % debugBackgroundColors.count) + debugBackgroundColors.count) % debugBackgroundColors.count
            assert(randomIndex >= 0 && randomIndex < debugBackgroundColors.count)
            let randomColor = debugBackgroundColors[randomIndex]

            return background(randomColor)
        }
    }

#endif
