#if USE_SCUI
    import SwiftCrossUI
#else
    import SwiftUI
#endif

struct UnitRectangle: Shape {
    #if USE_SCUI
        func path(in bounds: Path.Rect) -> Path {
            Rectangle().path(in: bounds)
        }

        func size(fitting proposal: SIMD2<Int>) -> ViewSize {
            let width = max(proposal.x, 1)
            return ViewSize(
                size: SIMD2(
                    width,
                    Int(5000 / Double(width))
                ),
                idealSize: SIMD2(x: 10, y: 5000 / 10),
                minimumWidth: 0,
                minimumHeight: 0,
                maximumWidth: nil,
                maximumHeight: nil
            )
        }
    #else
        func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
            let width = max(proposal.width ?? 10, 1)
            return CGSize(
                width: width,
                height: 5000 / width
            )
        }

        func path(in rect: CGRect) -> Path {
            Rectangle().path(in: rect)
        }
    #endif
}

/// This isn't an edge case, it just helped my understand what was going on.
struct UnitRectangleExample: View {
    @State var spacerWidth: SliderValue = 300

    var body: some View {
        VStack {
            UnitRectangle()
                .fill(.green)
                #if !USE_SCUI
                    .layoutPriority(1)
                #endif
            Spacer()
                .frame(width: spacerWidth)
                .background(Color.blue)
                #if !USE_SCUI
                    .layoutPriority(1)
                #endif
        }
        .fixedSize(horizontal: true, vertical: false)
        .background(Color.red)

        VStack {
            HStack {
                Text("Spacer:")
                #if USE_SCUI
                    Slider($spacerWidth, minimum: 10, maximum: 400)
                #else
                    Slider(value: $spacerWidth, in: 10...400)
                #endif
            }
        }.frame(width: 200)
    }
}
