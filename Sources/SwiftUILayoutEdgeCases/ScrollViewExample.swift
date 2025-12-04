#if USE_SCUI
    import SwiftCrossUI
#else
    import SwiftUI
#endif

struct ScrollViewExample: View {
    var body: some View {
        Text("Plug in a wired mouse so that the scroll bar has width, and then scroll on the blue square and watch as the scroll bar flickers in and out of existence. Clicking anywhere in the app should also trigger the flickering")
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: 600)
            .padding(.bottom)

        ScrollView {
            Color.blue
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: 401, height: 400)
    }
}
