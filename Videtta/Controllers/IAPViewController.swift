

//import UIKit
//import StoreKit
//
//class IAPViewController: UIViewController
//    //    , SKPaymentTransactionObserver, SKProductsRequestDelegate
//{
//
//    //@IBOutlet weak var premiumBtn: UIButton!
//
//    @IBOutlet weak var tableView: UITableView!
//
//    var isUnlockPremium = false
//
//    //    var productsReq = SKProductsRequest()
//    //
//    //    var validProducts = [SKProduct]()
//    //
//    //    var productIndex = 0
//
//    var products: [SKProduct] = []
//
//    let productId = "com.videtta.PremiumVers"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //premiumBtn.isEnabled = false
//
//        //fetchAvailableProducts()
//
//        NotificationCenter.default.addObserver(self,selector: #selector(unlock),name: NSNotification.Name("unlock"),object: nil)
//
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        reload()
//    }
//
//    @objc func reload() {
//        products = []
//
//        tableView.reloadData()
//
//        VidettaProducts.store.requestProducts{ [weak self] success, products in
//            guard let self = self else { return }
//            if success {
//                self.products = products!
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
//
//    @objc func unlock() {
//        let ud = UserDefaults.standard
//        isUnlockPremium = true
//        ud.set(isUnlockPremium, forKey: "unlock")
//        NotificationCenter.default.post(name: NSNotification.Name("UnlockAll"),
//                                        object: nil)
//        self.showAlertAndExit("You have gained access to all functions of 'Videtta: Video Maker'!")
//    }
//
//    @objc func handlePurchaseNotification(_ notification: Notification) {
//        guard
//            let productID = notification.object as? String,
//            let index = products.firstIndex(where: { product -> Bool in
//                product.productIdentifier == productID
//
//            })
//            else { return }
//
//        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
//    }
//
//    //    func fetchAvailableProducts() {
//    //
//    //        let productIdIn = "com.videtta.PremiumVers"
//    //
//    //        productsReq = SKProductsRequest(productIdentifiers: [productIdIn])
//    //        productsReq.delegate = self
//    //        productsReq.start()
//    //
//    //    }
//    //
//    //    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//    //
//    //        for transaction in transactions {
//    //            switch transaction.transactionState {
//    //
//    //            case .purchased:
//    //
//    //                if (productIndex == 0) {
//    //                    let ud = UserDefaults.standard
//    //                    isUnlockPremium = true
//    //                    ud.set(isUnlockPremium, forKey: "unlock")
//    //                    NotificationCenter.default.post(name: NSNotification.Name("UnlockAll"),
//    //                                                    object: nil)
//    //                    self.showAlertAndExit("You have gained access to all functions of 'Videtta: Video Maker'!")
//    //                }
//    //                SKPaymentQueue.default().finishTransaction(transaction)
//    //                break
//    //
//    //            case .restored:
//    //
//    //                if (transaction.payment.productIdentifier == productId) {
//    //                    let ud = UserDefaults.standard
//    //                    isUnlockPremium = true
//    //                    ud.set(isUnlockPremium, forKey: "unlock")
//    //                    NotificationCenter.default.post(name: NSNotification.Name("UnlockAll"),
//    //                                                    object: nil)
//    //                    self.showAlertAndExit("You have gained access to all functions of 'Videtta: Video Maker'!")
//    //                }
//    //                SKPaymentQueue.default().finishTransaction(transaction)
//    //                break
//    //
//    //            case .failed:
//    //                SKPaymentQueue.default().finishTransaction(transaction)
//    //                break
//    //
//    //            case .deferred:
//    //                SKPaymentQueue.default().finishTransaction(transaction)
//    //                break
//    //
//    //            default:
//    //                break
//    //            }
//    //        }
//    //    }
//    //
//    //    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//    //
//    //        if (response.products.count > 0) {
//    //            validProducts = response.products
//    //            let premiumProd = response.products[0] as SKProduct
//    //            print(premiumProd.localizedDescription)
//    //            print(premiumProd.localizedTitle)
//    //
//    //            DispatchQueue.main.async {
//    //                //self.premiumBtn.isEnabled = true
//    //            }
//    //        }
//    //
//    //    }
//    //
//    //    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
//    //        true
//    //    }
//    //
//    //    func canMakePurchase() -> Bool {
//    //        return SKPaymentQueue.canMakePayments()
//    //    }
//    //
//    //    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//    //        // Restore
//    //
//    //        for transaction in queue.transactions {
//    //            if transaction.transactionState == .restored {
//    //                if (transaction.payment.productIdentifier == productId) {
//    //                    let ud = UserDefaults.standard
//    //                    isUnlockPremium = true
//    //                    ud.set(isUnlockPremium, forKey: "unlock")
//    //                    NotificationCenter.default.post(name: NSNotification.Name("UnlockAll"),
//    //                                                    object: nil)
//    //                    self.showAlertAndExit("You have gained access to all functions of 'Videtta: Video Maker'!")
//    //                }
//    //                SKPaymentQueue.default().finishTransaction(transaction)
//    //                break
//    //
//    //            }
//    //        }
//    //    }
//
//    func showAlert(_ message: String, isError: Bool) {
//        // Show info/alert
//        let alert = UIAlertController(title: isError ? "Error!" : "Congratulations!", message: message, preferredStyle: .alert)
//
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func showAlertAndExit(_ message: String) {
//        // Show info/alert
//        let alert = UIAlertController(title: "Congratulations!", message: message, preferredStyle: .alert)
//
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler:
//        {
//            (action) in
//            self.dismiss(animated: true, completion: nil)
//        })
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    //    func purchase(_ product: SKProduct) {
//    //        // Start payment transactions
//    //        if self.canMakePurchase() {
//    //            let payment = SKPayment(product: product)
//    //
//    //            SKPaymentQueue.default().add(self)
//    //            SKPaymentQueue.default().add(payment)
//    //        } else {
//    //            self.showAlert("Purchases are disabled in your device!", isError: true)
//    //        }
//    //    }
//
//    @IBAction func close(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    //    @IBAction func buyPremium(_ sender: UIButton) {
//    //        productIndex = 0
//    //        purchase(validProducts[productIndex])
//    //    }
//
//    @IBAction func restore(_ sender: UIButton) {
//        VidettaProducts.store.restorePurchases()
//    }
//
//}
//
//extension IAPViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return products.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCell
//
//        let product = products[(indexPath as NSIndexPath).row]
//
//        cell.layer.cornerRadius = 10
//
//        cell.layer.shadowColor = UIColor.blue.cgColor
//        cell.layer.shadowRadius = 5.5
//        cell.layer.shadowOpacity = 1.1
//        cell.layer.shadowOffset = CGSize.zero
//        cell.layer.borderColor = UIColor.darkGray.cgColor
//        cell.layer.borderWidth = 1.5
//        cell.layer.masksToBounds = false
//
//        cell.product = product
//        cell.buyButtonHandler = { product in
//            VidettaProducts.store.buyProduct(product)
//        }
//
//        return cell
//    }
//}
