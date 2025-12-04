#if USE_SCUI
    import SwiftCrossUI
#else
    import SwiftUI
#endif

struct AspectRatioExample: View {
    @State var idealTextWidth: SliderValue = 51

    var body: some View {
        Text("Similar to heightBasedUnitRectangle, the text's ideal state is having 8 lines of text (with an idealTextWidth of 51). The square takes up the rest of the available height.\n\nThe square ends up being wider than the wider, so its width is used as the width of the stack. The stack then performs its final layout pass. First, the text gets allocated 50% of the available height and the square's original ideal width. This means that it takes up less height than original.\n\nThe square then gets given its original ideal width as well as all remaining height. It's a square so it takes up all the width and leaves some height left over.\n\nThe stack's contents now end up shorter than the stack expected, leading to the stack not hugging its content as you'd usually expect.")
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: 600)
            .padding(.bottom)

        VStack {
            Text("Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet")
                .frame(idealWidth: idealTextWidth)
                .fixedSize(horizontal: false, vertical: true)
                .background(Color.green)
                #if !USE_SCUI
                    .layoutPriority(1)
                #endif
            Color.blue
                .aspectRatio(1, contentMode: .fit)
                #if !USE_SCUI
                    .layoutPriority(1)
                #endif
        }
        .fixedSize(horizontal: true, vertical: false)
        .frame(height: 400)
        .background(Color.red)

        VStack {
            HStack {
                Text("Text idealWidth (\(Int(idealTextWidth))):").fixedSize()
                    .frame(width: 100, alignment: .trailing)
                #if USE_SCUI
                    Slider($idealTextWidth, minimum: 10, maximum: 400)
                #else
                    Slider(value: $idealTextWidth, in: 10...400)
                #endif
            }
        }.frame(width: 400)
    }
}
