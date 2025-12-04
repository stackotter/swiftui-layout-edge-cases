#if USE_SCUI
    import SwiftCrossUI
#else
    import SwiftUI
#endif

struct HeightBasedUnitRectangle: Shape {
    #if USE_SCUI
        func path(in bounds: Path.Rect) -> Path {
            Rectangle().path(in: bounds)
        }

        func size(fitting proposal: SIMD2<Int>) -> ViewSize {
            let height = max(proposal.y, 1)
            return ViewSize(
                size: SIMD2(
                    Int(100000 / Double(height)),
                    height,
                ),
                idealSize: SIMD2(x: 300, y: 100000 / 300),
                minimumWidth: 0,
                minimumHeight: 0,
                maximumWidth: nil,
                maximumHeight: nil
            )
        }
    #else
        func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
            let height = max(proposal.height ?? 200, 1)
            return CGSize(
                width: 100000 / height,
                height: height
            )
        }

        func path(in rect: CGRect) -> Path {
            Rectangle().path(in: rect)
        }
    #endif
}

struct HeightBasedUnitRectangleExample: View {
    @State var idealTextWidth: SliderValue = 51

    var body: some View {
        Text("When the ideal text width is set to 51, the text view will want to take up 8 lines of space. This leaves the rest of the stack's height for the rectangle to use. The rectangle's width is computed from its proposed height such that it always has an area of 100000 pt^2.\n\nWhen the rectangle is shorter, it is wider (similar to Text). The rectangle ends up having the widest ideal width, which the stack then choose as its own width.\n\nWhen the stack performs its final layout pass, the text takes on close to the ideal width of the rectangle, which makes it less tall. The rectangle then gets allocated more height than it was originally allocated, making it thinner.\n\nThe layout is now in a state where the only reason that it's so wide is a view that ends up not being very wide in the final layout. The text doesn't quite take on the rectangle's original ideal width, which makes the final stack thinner than expected, causing the alignment issue.")
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: 600)
            .padding(.bottom)

        VStack {
            Text("Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.")
                .frame(idealWidth: idealTextWidth)
                .fixedSize(horizontal: false, vertical: true)
                .background(Color.green)
                #if !USE_SCUI
                    .layoutPriority(1)
                #endif

            HeightBasedUnitRectangle()
                .fill(.blue)
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
