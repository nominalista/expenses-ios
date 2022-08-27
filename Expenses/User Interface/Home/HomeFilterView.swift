import SwiftUI

struct HomeFilterView: View {
    var body: some View {
        HStack(spacing: 16) {
            FilterButton(
                action: {},
                image: .init(systemName: "calendar"),
                text: Text("All time")
            )
            FilterButton(
                action: {},
                image: .init(systemName: "tag.fill"),
                text: Text("All tags")
            )
        }
    }
}

extension HomeFilterView {
    struct FilterButton: View {
        struct Style: ButtonStyle {
            var visualEffectView: some View {
                VisualEffectView(effect: UIBlurEffect(style: .regular))
                    .environment(\.colorScheme, .light)
                    .opacity(0.25)
            }
            
            func makeBody(configuration: Configuration) -> some View {
                configuration
                    .label
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(visualEffectView)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        
        var action: (() -> Void)
        var image: Image
        var text: Text
        
        var body: some View {
            Button {
                action()
            } label: {
                HStack(alignment: .center, spacing: 8) {
                    image
                        .resizable()
                        .font(.system(.body, design: .rounded).weight(.bold))
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.label)
                    text
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundColor(.label)
                }
            }
            .buttonStyle(Style())
        }
    }
}

struct HomeFilterView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFilterView()
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
