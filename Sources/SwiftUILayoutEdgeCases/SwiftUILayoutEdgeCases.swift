#if USE_SCUI
    import SwiftCrossUI
    import DefaultBackend
    typealias SliderValue = Int
#else
    import SwiftUI
    typealias SliderValue = Double
#endif

enum EdgeCase: String, CaseIterable, Identifiable, Hashable, Sendable {
    case aspectRatio
    case heightBasedUnitRectangle
    case scrollView

    var id: EdgeCase {
        self
    }
}

@main
struct SwiftUILayoutEdgeCases: App {
    @State
    var edgeCase: EdgeCase?

    var body: some Scene {
        WindowGroup {
            #if USE_SCUI
                Text("Note: SwiftCrossUI doesn't behave correctly under these examples yet. I only included SwiftCrossUI support so that I can test for these as I fix up the layout system over the next few days.")
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 400)
            #endif

            VStack {
                #if USE_SCUI
                    Picker(of: EdgeCase.allCases, selection: $edgeCase)
                #else
                    Picker("Edge case", selection: $edgeCase) {
                        ForEach(EdgeCase.allCases) { edgeCase in
                            Text("\(edgeCase)")
                                .tag(edgeCase)
                        }
                    }.frame(width: 300)
                #endif
            }
            .padding(.top)

            VStack {
                switch edgeCase {
                    case .aspectRatio:
                        AspectRatioExample()
                    case .heightBasedUnitRectangle:
                        HeightBasedUnitRectangleExample()
                    case .scrollView:
                        ScrollViewExample()
                    default:
                        Text("Choose an example")
                }
            }
            .frame(width: 500)
            .padding()
        }
    }
}
