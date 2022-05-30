import SwiftUI

struct SubscriptionRow: View {

    var subscription: Subscription
    var isSelected: Bool
    var didSelect: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                didSelect()
            } label: {
                HStack(spacing: 0) {
                    selectionImage
                    Spacer().frame(width: 16)
                    labelStack
                    Spacer()
                }
            }
        }
        .padding(16)
        .backgroundColor(.secondarySystemBackground)
        .cornerRadius(16)
        .overlay(overlay)
    }
    
    private var selectionImage: some View {
        let imageName = isSelected ? "checkmark.circle.fill" : "circle"
        let imageColor: Color = isSelected ? .brandPrimary : .secondaryLabel
        return Image(systemName: imageName)
            .font(.system(.body).weight(.semibold))
            .frame(width: 24, height: 24, alignment: .center)
            .foregroundColor(imageColor)
    }
    
    private var labelStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(subscription.displayName)
                .font(.headline)
                .foregroundColor(.label)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
            
            HStack(spacing: 4) {
                Text(subscription.displayPrice)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.label)
                
                if let periodUnit = subscription.displayPeriodUnit {
                    Text("/ \(periodUnit)")
                        .font(.subheadline)
                        .foregroundColor(.secondaryLabel)
                }
            }
            
            Text(subscription.description)
                .font(.subheadline)
                .foregroundColor(.secondaryLabel)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
        }
    }

    private var overlay: some View {
        RoundedRectangle(cornerRadius: 16)
            .strokeBorder(Color.brandPrimary, lineWidth: isSelected ? 2 : 0)
    }
}
