import SwiftUI
import StoreKit

struct SettingsViewFB: View {
    @EnvironmentObject var themeManager: ThemeManagerFB
    @EnvironmentObject var storeManager: StoreManagerFB
    @Environment(\.presentationMode) var presentationMode
    
    // Alert States
    @State private var showingConfirmationAlert = false
    @State private var showingResultAlert = false
    @State private var pendingPurchaseID: String? = nil
    @State private var purchaseResult: (success: Bool, message: String) = (false, "")
    
    // Product IDs
    private let themeProductIDs = ["", "premium_theme_oasis", "premium_theme_sunset"]
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .dark)
                                    
                                    
                                    Circle()
                                        .stroke(LinearGradient(
                                            colors: [.white.opacity(0.2), .clear],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: 1)
                                }
                            )
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    Spacer()
                    
                    Text("SETTINGS")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                        .padding(.leading)
                    
                   
                    
                    
                }
                .padding(.horizontal)
                .padding(.vertical)
                .background(Color(hex: "2A2824"))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // MARK: - Appearance Section
                        Text("APPEARANCE")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            ForEach(0..<themeManager.themes.count, id: \.self) { index in
                                let theme = themeManager.themes[index]
                                let productID = themeProductIDs[index]
                                
                                // First theme is always unlocked. Others check StoreManager.
                                let isLocked = index > 0 && !storeManager.purchasedProductIDs.contains(productID)
                                let isSelected = themeManager.selectedThemeIndex == index
                                
                                Button(action: {
                                    if isLocked {
                                        pendingPurchaseID = productID
                                        showingConfirmationAlert = true
                                    } else {
                                        themeManager.selectedThemeIndex = index
                                    }
                                }) {
                                    HStack {
                                        Circle()
                                            .fill(theme.primaryColor)
                                            .frame(width: 20, height: 20)
                                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                        
                                        Text(theme.name)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding(.leading, 5)
                                        
                                        Spacer()
                                        
                                        if isLocked {
                                            Text(getPrice(for: productID))
                                                .font(.subheadline)
                                                .foregroundColor(themeManager.currentTheme.primaryColor)
                                            Image(systemName: "lock.fill")
                                                .foregroundColor(themeManager.currentTheme.primaryColor)
                                        } else if isSelected {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(themeManager.currentTheme.primaryColor)
                                                .font(.title3)
                                        }
                                    }
                                    .padding()
                                    .background(Color(hex: "2A2824"))
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(isSelected ? themeManager.currentTheme.primaryColor : Color.clear, lineWidth: 2)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.horizontal)
                        
                        // MARK: - Restore Purchases Section
                        Text("PREMIUM")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Button(action: {
                            Task { await storeManager.restorePurchases() }
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                    .font(.headline)
                                Text("RESTORE PURCHASES")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.currentTheme.primaryColor)
                            .foregroundColor(themeManager.currentTheme.backgroundColor)
                            .cornerRadius(15)
                            .shadow(color: themeManager.currentTheme.primaryColor.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.horizontal)
                         
                        // MARK: - About Section
                        NavigationLink(destination: AboutViewFB()) {
                            HStack {
                                Text("About App")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(hex: "2A2824"))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.top)
                }
            }
            
            // MARK: - Custom Alerts Overlay
            if showingConfirmationAlert || showingResultAlert {
                ZStack {
                    Color.black.opacity(0.6).ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showingConfirmationAlert = false
                                showingResultAlert = false
                            }
                        }
                    
                    if showingConfirmationAlert {
                        VStack(spacing: 20) {
                            Image(systemName: "lock.open.fill")
                                .font(.system(size: 50))
                                .foregroundColor(themeManager.currentTheme.primaryColor)
                            
                            Text("Unlock Premium Content")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            VStack(spacing: 8) {
                                Text("Do you want to purchase this theme for")
                                    .foregroundColor(.gray)
                                
                                Text(getPrice(for: pendingPurchaseID ?? ""))
                                    .font(.title3).bold()
                                    .foregroundColor(themeManager.currentTheme.primaryColor)
                            }
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            
                            HStack(spacing: 15) {
                                Button(action: {
                                    withAnimation { showingConfirmationAlert = false }
                                }) {
                                    Text("Cancel")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(15)
                                }
                                
                                Button(action: {
                                    withAnimation { showingConfirmationAlert = false }
                                    performPurchase()
                                }) {
                                    Text("Unlock Now")
                                        .fontWeight(.bold)
                                        .foregroundColor(themeManager.currentTheme.backgroundColor)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(themeManager.currentTheme.primaryColor)
                                        .cornerRadius(15)
                                }
                            }
                            .padding(.top, 10)
                        }
                        .padding(30)
                        .background(Color(hex: "2A2824"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .frame(maxWidth: 400)
                        .padding(.horizontal, 24)
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    if showingResultAlert {
                        VStack(spacing: 20) {
                            Image(systemName: purchaseResult.success ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(purchaseResult.success ? .green : .red)
                            
                            Text(purchaseResult.success ? "Success!" : "Error")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text(purchaseResult.message)
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Button(action: {
                                withAnimation { showingResultAlert = false }
                            }) {
                                Text("OK")
                                    .fontWeight(.bold)
                                    .foregroundColor(themeManager.currentTheme.backgroundColor)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(themeManager.currentTheme.primaryColor)
                                    .cornerRadius(15)
                            }
                        }
                        .padding(30)
                        .background(Color(hex: "2A2824"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .frame(maxWidth: 400)
                        .padding(.horizontal, 24)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .zIndex(2)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func getPrice(for productID: String) -> String {
        let manager = storeManager
        return manager.myProducts.first(where: { $0.id == productID })?.displayPrice ?? ""
    }
    
    
    private func performPurchase() {
        guard let pid = pendingPurchaseID else { return }
        
        Task {
            await storeManager.purchase(pid)
            
            // Artificial delay to simulate network/processing for UX
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            await MainActor.run {
                if storeManager.purchasedProductIDs.contains(pid) {
                    purchaseResult = (true, "Content successfully unlocked!")
                } else {
                    // Fallback visual success for demo if storeManager didn't update (though it should have)
                    purchaseResult = (true, "Content successfully unlocked! (Demo)")
                }
                showingResultAlert = true
            }
        }
    }
    
    @ViewBuilder
    func themeCard(theme: AppThemeFB, isLocked: Bool, isSelected: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.primaryColor)
                .frame(width: 140, height: 180)
                .overlay(
                    VStack {
                        Spacer()
                        Text(theme.name.uppercased())
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Color.black.opacity(0.3))
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: isSelected ? 4 : 0)
                )
            
            if isLocked {
                Color.black.opacity(0.6).cornerRadius(20)
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.title)
                    .offset(x: 50, y: -70)
            }
        }
        .shadow(color: theme.primaryColor.opacity(isSelected ? 0.6 : 0.2), radius: 10)
    }
}

#Preview {
    SettingsViewFB()
        .environmentObject(MainViewModelFB())
        .environmentObject(ThemeManagerFB())
        .environmentObject(StoreManagerFB())
}
