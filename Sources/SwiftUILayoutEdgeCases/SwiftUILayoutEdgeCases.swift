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
    #if !USE_SCUI
        case windowSizing
    #endif

    var id: EdgeCase {
        self
    }
}

enum WindowEdgeCase: String, CaseIterable, Identifiable, Hashable, Sendable {
    case vStackIncorrectMinimumHeight
    case fixedSizeHStackIncorrectMinimumHeight

    var id: WindowEdgeCase {
        self
    }
}

@main
struct SwiftUILayoutEdgeCases: App {
    #if !USE_SCUI
        @Environment(\.openWindow) var openWindow
        @Environment(\.dismissWindow) var dismissWindow
    #endif

    @State
    var edgeCase: EdgeCase?

    @State
    var windowEdgeCase = WindowEdgeCase.vStackIncorrectMinimumHeight

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
                    #if !USE_SCUI
                        case .windowSizing:
                            VStack {
                                Picker("Window edge case", selection: $windowEdgeCase) {
                                    ForEach(WindowEdgeCase.allCases) { edgeCase in
                                        Text("\(edgeCase)")
                                            .tag(edgeCase)
                                    }
                                }
                                .frame(width: 300)
                                .padding(.bottom)

                                switch windowEdgeCase {
                                    case .vStackIncorrectMinimumHeight:
                                        Text("SwiftUI takes some shortcuts to compute stack sizing more efficiently. To compute the minimum height of a VStack, it computes the minimum heights of its children and adds them up with any relevant spacing.\n\nIn this example, SwiftUI adds the minimum heights of the two rectangles together to get 85. When the window is at its minimum height, the VStack gets proposed a height of 85. The blue rectangle has lower flexibility, so it goes first and gets allocated a height of 42 (half of 85). It accepts that height. The orange rectangle then gets allocated the remaining height, 43, and rejects it because its minimum height is 80. The VStack ends up with a height of 80 + 43 = 123, which is much bigger than its reported minimum height of 85.\n\nIn my opinion, the minimum height of a view should be the minimum height that it can be allocated AND accept. That's what SwiftCrossUI currently computes, and I think it's more correct. However, computing the actual minimum height is quite expensive because it requires computing child layouts more than once, leading to exponential branching as you add more layers to your view hierarchy.")
                                            .fixedSize(horizontal: false, vertical: true)
                                            .frame(width: 600)
                                            .padding(.bottom)
                                    case .fixedSizeHStackIncorrectMinimumHeight:
                                        Text("When computing the minimum size of a window, SwiftUI simply proposes 0x0 to its root content view and uses the resulting size as the window's minimum size. In my opinion, the better alternative - which SwiftCrossUI does - is to propose 0 x currentHeight and currentWidth x 0 separately to compute the root content view's minimum width for the current height and minimum height for the current width. SwiftCrossUI's behaviour leads to the window always being able to be resized to hug the content.\n\nIn this example you can see that the window's minimum height is way bigger than the content. This happens because when the root content view gets allocated 0x0, the Text uses a width of 0 to compute its fixed height, leading to the 'minimum height' of the window's content being the height that you get when you stack all of the text characters one on top of another.")
                                            .fixedSize(horizontal: false, vertical: true)
                                            .frame(width: 600)
                                            .padding(.bottom)
                                }
                            }
                            .onAppear {
                                windowEdgeCase = .vStackIncorrectMinimumHeight
                                openWindow(id: "windowSizing")
                            }
                            .onDisappear {
                                dismissWindow(id: "windowSizing")
                            }
                    #endif
                    default:
                        Text("Choose an example")
                }
            }
            .frame(width: 500)
            .padding()
        }

        #if !USE_SCUI
            Window("Window sizing example", id: "windowSizing") {
                VStack {
                    switch windowEdgeCase {
                        case .vStackIncorrectMinimumHeight:
                            VStack(spacing: 0) {
                                Color.blue
                                    .frame(minHeight: 5, maxHeight: 100)
                                Color.orange
                                    .frame(minHeight: 80)
                            }
                            .border(.red)
                            .padding()
                        case .fixedSizeHStackIncorrectMinimumHeight:
                            HStack {
                                Color.orange.frame(width: 5)

                                Text("Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.")
                            }
                            .background(Color.gray)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .onDisappear {
                    edgeCase = nil
                }
            }
            .restorationBehavior(.disabled)
            .defaultLaunchBehavior(.suppressed)
        #endif
    }
}
