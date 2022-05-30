import SwiftUI

struct ExpensesPlusView: View {
    
    @StateObject var viewModel: ExpensesPlusViewModel
    
    @State var isFailedPurchaseAlertPresented = false
    
    @Environment(\.dismiss) var dismiss
    
    init() {
        _viewModel = StateObject(wrappedValue: ExpensesPlusViewModel())
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView(showsIndicators: false) {
                        content
                    }
                }
            }
            .alert(
                "Sorry!",
                isPresented: $isFailedPurchaseAlertPresented,
                actions: {
                    Button("OK", role: .cancel) {}
                },
                message: {
                    Text("Something went wrong. Try again.")
                }
            )
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .backgroundColor(.systemBackground)
            .toolbar { toolbar }
        }
        .onReceive(viewModel.dismissPublisher) { _ in
            dismiss()
        }
        .onReceive(viewModel.failedPurchasePublisher) { _ in
            isFailedPurchaseAlertPresented.toggle()
        }
    }

    private var content: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(spacing: 8) {
                logo
                title
            }
            
            Spacer().frame(height: 32)
                        
            VStack(spacing: 8) {
                incentive(checked: true, text: "Adding new wallets")
                incentive(checked: true, text: "Sharing wallets with friends")
                incentive(checked: true, text: "Unlimited incomes/expenses")
                incentive(checked: false, text: "…and more!")
            }
            
            Spacer().frame(height: 32)
            
            ForEach(
                Array(viewModel.subscriptions.enumerated()),
                id: \.offset
            ) { index, subscription in
                SubscriptionRow(
                    subscription: subscription,
                    isSelected: subscription.id == viewModel.selectedSubscriptionID
                ) {
                    viewModel.select(subscriptionWithID: subscription.id)
                }
                if index < viewModel.subscriptions.count - 1 {
                    Spacer().frame(height: 16)
                }
            }
            
            Spacer().frame(height: 32)

            VStack(spacing: 16) {
                agreement
                subscribeButton
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 32)
    }
    
    private var logo: some View {
        Image.imgLogo
            .resizable()
            .frame(width: 64, height: 64)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
    }
    
    private var title: some View {
        Text("Expenses")
            .font(.largeTitle.weight(.black))
            .foregroundColor(.label)
        +
        Text("+")
            .font(.largeTitle.weight(.black))
            .foregroundColor(.brandPrimary)
    }
        
    private func incentive(checked: Bool, text: String) -> some View {
        HStack(spacing: 16) {
            if checked {
                Image.icCheck24pt.foregroundColor(.brandPrimary)
            } else {
                Spacer().frame(width: 24, height: 24)
            }
            Text(text)
                .font(.body)
                .foregroundColor(.label)
            Spacer()
        }
    }
    
    private var agreement: some View {
        Group {
            Text("By starting a trial or subscription, you agree to the ")
                .font(.footnote)
                .foregroundColor(.secondaryLabel)
            + Text("Terms\u{00a0}and\u{00a0}Conditions")
                .font(.footnote.weight(.medium))
                .foregroundColor(.brandPrimary)
            + Text(" and ")
                .font(.footnote)
                .foregroundColor(.secondaryLabel)
            + Text("Privacy\u{00a0}Policy")
                .font(.footnote.weight(.medium))
                .foregroundColor(.brandPrimary)
            + Text(".")
                .font(.footnote)
                .foregroundColor(.secondaryLabel)
        }
        .multilineTextAlignment(.center)
    }
    
    private var subscribeButton: some View {
        Button {
            viewModel.purchase()
        } label: {
            HStack {
                Spacer()
                if viewModel.isPurchasing {
                    ProgressView()
                        .environment(\.colorScheme, .dark)
                } else {
                    Text("Subscribe")
                        .foregroundColor(.onBrandPrimary)
                        .font(.headline)
                }
                Spacer()
            }
        }
        .padding(16)
        .backgroundColor(.brandPrimary)
        .clipShape(Capsule())
    }
    
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image.icClose24pt
            }
            .buttonStyle(.toolbarIcon)
        }
    }
}

struct ExpensesPlusView_Previews: PreviewProvider {
    
    static var previews: some View {
        ExpensesPlusView()
    }
}
