import Foundation
import StoreKit
import Combine

@MainActor
class StoreManagerFB: ObservableObject {
    @Published var myProducts: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    
    private var transactionListener: Task<Void, Error>?
    
    private let productIds = ["com.fezbet.theme.oasis", "com.fezbet.theme.sunset"]
    
    init() {
        transactionListener = listenForTransactions()
        Task {
            await updatePurchasedProducts()
            await requestProducts()
        }
    }
    
    deinit {
            transactionListener?.cancel()
        }
    
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                if let transaction = try? result.payloadValue {
                    await _ = MainActor.run { self.purchasedProductIDs.insert(transaction.productID) }
                    await transaction.finish()
                }
            }
        }
    }
    
    func requestProducts() async {
        do {
            self.myProducts = try await Product.products(for: productIds)
        } catch {
            print("❌ Ошибка StoreKit: \(error)")
        }
    }
    
    func purchase(_ productID: String) async {
        guard let product = myProducts.first(where: { $0.id == productID }) else { return }
        
        do {
            let result = try await product.purchase()
            if case .success(let verification) = result,
               case .verified(let transaction) = verification {
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
            }
        } catch {
            print("❌ Ошибка покупки: \(error)")
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if let transaction = try? result.payloadValue {
                self.purchasedProductIDs.insert(transaction.productID)
            }
        }
    }
    
    func restorePurchases() async {
        try? await AppStore.sync()
        await updatePurchasedProducts()
    }
}

