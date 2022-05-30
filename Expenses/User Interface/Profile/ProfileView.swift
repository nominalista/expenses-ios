//
//  ProfileView.swift
//  Expenses
//
//  Created by Nominalista on 12/02/2022.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    
    @State var isProfileIDShareSheetPresented = false
    @State var isDeleteAccountConfirmationAlertPresented = false
    @State var isAccountDeletedConfirmationAlertPresented = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    private var userInitials: String {
        let formatter = PersonNameComponentsFormatter()
        formatter.style = .abbreviated
        
        guard let components = formatter.personNameComponents(
            from: viewModel.userDisplayName
        ) else {
            return "NN"
        }
        return formatter.string(from: components)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    accountRow
                    
                    if viewModel.hasExpensesPlus {
                        expensesPlusRow
                    }
                    
                    profileIDRow
                    deleteAccountRow
                    logOutRow
                }
                
                Section(header: Text("About")) {
                    githubRow
                    termsAndConditionsRow
                    privacyPolicyRow
                }
                .headerProminence(.increased)
                
                Section {
                    disclaimerRow
                }
            }
            .sheet(isPresented: $isProfileIDShareSheetPresented) {
                LazyView {
                    ShareSheet(activityItems: [viewModel.profileID]) {}
                }
            }
            .toolbar {
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
    }
    
    private var accountRow: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .foregroundColor(.brandPrimary)
                        .frame(width: 64, height: 64)
                    Text(userInitials)
                        .font(.title).fontWeight(.bold)
                        .foregroundColor(.label)
                        .environment(\.colorScheme, .dark)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(viewModel.userDisplayName)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.label)
                    
                    Text(viewModel.userEmail)
                        .font(.body)
                        .foregroundColor(.secondaryLabel)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var avatarRow: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .foregroundColor(.brandPrimary)
                        .frame(width: 80, height: 80)
                    Text(userInitials)
                        .font(.title).fontWeight(.bold)
                        .foregroundColor(.label)
                        .environment(\.colorScheme, .dark)
                }
                
                Spacer().frame(height: 8)
                
                Text(viewModel.userDisplayName)
                    .font(.headline)
                    .foregroundColor(.label)
                
                Text(viewModel.userEmail)
                    .font(.body)
                    .foregroundColor(.secondaryLabel)
            }

            Spacer()
        }
        .listRowStyle(.plain)
    }
    
    private var expensesPlusRow: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Expenses")
                    .font(.body)
                    .foregroundColor(.label)
                +
                Text("+")
                    .font(.headline)
                    .foregroundColor(.brandPrimary)
                
                Text("Your subscription is active.")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var profileIDRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Profile ID")
                    .font(.body)
                    .foregroundColor(.label)
                Text("Become a wallet contributor.")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button {
                isProfileIDShareSheetPresented.toggle()
            } label: {
                Text("Share")
                    .font(.headline)
                    .foregroundColor(.brandPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .backgroundColor(.tertiarySystemGroupedBackground)
            .clipShape(Capsule())
        }
        .padding(.vertical, 8)
    }
    
    private var deleteAccountRow: some View {
        Button {
            isDeleteAccountConfirmationAlertPresented.toggle()
        } label: {
            HStack(spacing: 8) {
                if viewModel.isDeletingAccount {
                    ProgressView()
                    Text("Deleting account…")
                        .font(.body)
                        .foregroundColor(.secondaryLabel)
                } else {
                    Text("Delete account")
                        .font(.body)
                        .foregroundColor(.label)
                }
                Spacer()
            }
        }
        .alert(
            "Delete account?",
            isPresented: $isDeleteAccountConfirmationAlertPresented,
            actions: {
                Button("Delete", role: .destructive) { viewModel.deleteAccount() }
                Button("Cancel", role: .cancel) {}
            }
        )
        .alert(
            "Account deleted",
            isPresented: $isAccountDeletedConfirmationAlertPresented,
            actions: {
                Button("Log out", role: .cancel) { viewModel.logOut() }
            }
        )
        .onReceive(viewModel.showAccountDeletedConfirmation) { _ in
            isAccountDeletedConfirmationAlertPresented.toggle()
        }
    }
    
    private var logOutRow: some View {
        Button {
            dismiss()
            viewModel.logOut()
        } label: {
            Text("Log out")
                .font(.headline)
                .foregroundColor(.systemRed)
        }
    }
    
    private var githubRow: some View {
        Button {
            openURL(URL(string: "https://www.github.com/nominalista/expenses-ios")!)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Source code")
                        .font(.body)
                        .foregroundColor(.label)
                    Text("github.com/nominalista/expenses-ios")
                        .font(.subheadline)
                        .foregroundColor(.secondaryLabel)
                        .lineLimit(1)
                }
                .padding(.vertical, 8)
                Spacer()
            }
        }
    }
    
    private var termsAndConditionsRow: some View {
        Button {
            openURL(URL(string: "https://www.github.com/nominalista/expenses-ios")!)
        } label: {
            HStack {
                Text("Terms and conditions")
                    .font(.body)
                    .foregroundColor(.label)
                Spacer()
            }
        }
    }
    
    private var privacyPolicyRow: some View {
        Button {
            openURL(URL(string: "https://www.github.com/nominalista/expenses-ios")!)
        } label: {
            HStack {
                Text("Privacy policy")
                    .font(.body)
                    .foregroundColor(.label)
                Spacer()
            }
        }
    }
    
    private var disclaimerRow: some View {
        HStack {
            Spacer()
            VStack(spacing: 2) {
                Text("Made with ❤️ by nominalista")
                    .font(.body)
                    .foregroundColor(.label)
                
                Text("Version 1.0.0")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }
            
            Spacer()
        }
        .listRowStyle(.plain)
    }
}


private extension NavigationLink where Label == EmptyView, Destination == EmptyView {

   static var empty: NavigationLink {
       self.init(destination: EmptyView(), label: { EmptyView() })
   }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProfileView(viewModel: .preview)
    }
}
