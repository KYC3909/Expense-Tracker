//
//  AddTransactionsVC.swift
//  Expense Tracker
//
//  Created by Krunal on 1/9/22.
//

import UIKit

class AddTransactionsVC: UIViewController {

    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private(set) weak var segmentControl: UISegmentedControl!
    @IBOutlet private(set) weak var txtFieldDesc: UITextField!
    @IBOutlet private(set) weak var txtFieldAmount: UITextField!
    @IBOutlet private(set) weak var lblErrorDesc: UILabel!

    private var addTransactionViewModel: AddTransactionViewModelProtocol!
    
    override func viewDidLoad() { super.viewDidLoad()
        setupViews()
    }
    
    func assignViewModel(_ viewModel: AddTransactionViewModelProtocol) {
        self.addTransactionViewModel = viewModel
    }
}
// MARK: - Private Helper
extension AddTransactionsVC {
    // Setup View Layout
    private func setupViews() {
        // Add Blur View
        self.view.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        
        // Insert at Zero index
        self.view.insertSubview(blurEffectView, at: 0)
        
        viewContainer.cardView(.playstore)
        
        lblErrorDesc.text = " "
        segmentControl.selectedSegmentIndex = -1
    }
}

// MARK: - @IBActions
extension AddTransactionsVC {
    @IBAction func btnTransactionTypeSelected(_ sender: UIButton) {
        segmentControl.isHidden = !segmentControl.isHidden
    }
    @IBAction func segmentConrolSelected(_ sender: UISegmentedControl) {
    }
    @IBAction func btnIncreaseAmountSelected(_ sender: UIButton) {
        addTransactionViewModel.increaseAmount(txtFieldAmount.text ?? "")
    }
    @IBAction func btnDecreaseAmountSelected(_ sender: UIButton) {
        addTransactionViewModel.decreaseAmount(txtFieldAmount.text ?? "")
    }
    @IBAction func btnAddSelected(_ sender: UIButton) {
        self.addTransactionViewModel.addSelected(segmentControl.selectedSegmentIndex,
                                                 txtFieldDesc.text ?? "",
                                                 Int(txtFieldAmount.text ?? "") ?? 0)
    }

}
// MARK: - AddTransactionViewProtocol
extension AddTransactionsVC: AddTransactionViewProtocol {
    func transactionAddedSuccessful() {
        debugPrint("Transacion Added Successful")
    }
    func transactionErrorDesc(_ errorDesc: String) {
        lblErrorDesc.text = errorDesc
    }
    func transactionAmountUpdated(to value: Int) {
        txtFieldAmount.text = value.description
    }
}
