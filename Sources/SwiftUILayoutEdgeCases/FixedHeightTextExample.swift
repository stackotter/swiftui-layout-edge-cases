#if USE_SCUI
    import SwiftCrossUI
    import DefaultBackend
#else
    import SwiftUI
#endif

/// This isn't really an edge case, it just helped my understand what was going on. That
/// said, I do think that SwiftUI handles it a bit weirdly. The content of the VStack ends
/// up misaligned because the text ends up having less width than our user-provided ideal
/// text width (which is often unachievable due to line wrapping being non-continuous).
struct FixedHeightTextExample: View {
    @State var idealTextWidth: SliderValue = 280
    @State var spacerWidth: SliderValue = 250

    var body: some View {
        VStack {
            Text("Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.")
                .frame(idealWidth: idealTextWidth, alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
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
                Text("Text:")
                #if USE_SCUI
                    Slider($idealTextWidth, minimum: 10, maximum: 400)
                #else
                    Slider(value: $idealTextWidth, in: 10...400)
                #endif
            }

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
