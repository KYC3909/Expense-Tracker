//
//  AddTransactionsVC.swift
//  Expense Tracker
//
//  Created by Krunal on 1/9/22.
//

import UIKit
import Combine

class AddTransactionsVC: UIViewController {
    
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private(set) weak var stackContainerView: UIStackView!
    @IBOutlet private(set) weak var segmentControl: UISegmentedControl!
    
    @IBOutlet private(set) weak var viewTransactionType: UIView!
    @IBOutlet private(set) weak var viewTransactionTypeSelection: UIView!
    @IBOutlet private(set) weak var viewTransactionValueSelection: UIView!
    @IBOutlet private(set) weak var viewTransactionAmountSelection: UIView!

    
    @IBOutlet private(set) weak var txtFieldDesc: UITextField!
    @IBOutlet private(set) weak var txtFieldAmount: TextControl!
    
    @IBOutlet private(set) weak var lblErrorDesc: UILabel!
    @IBOutlet private(set) weak var addButtonContainerView: UIView!
    
    @IBOutlet private weak var tapGesture: UITapGestureRecognizer!

    private var addTransactionViewModel: AddTransactionViewModelProtocol!
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() { super.viewDidLoad()
        setupViews(); updateLayout(); updateViewLayout()
    }
    func assignViewModel(_ viewModel: AddTransactionViewModelProtocol) {
        self.addTransactionViewModel = viewModel
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.updateLayout()
        })
    }
    override func viewDidDisappear(_ animated: Bool) { super.viewDidDisappear(animated)
        self.addTransactionViewModel.dismissSelected(isDismissing: true)
    }
    deinit {
        debugPrint("AddTransactionsVC")
    }
}
// MARK: - Private Helper
extension AddTransactionsVC {
    // Setup View Layout
    private func setupViews() {
        viewContainer.cardView(.playstore)
        addButtonContainerView.cardView(.playstore)

        lblErrorDesc.text = " "
        segmentControl.selectedSegmentIndex = -1
        
        txtFieldAmount.setRules([NumericEntryAllowed()])
        txtFieldAmount.$validationErrorText.sink { [weak self] errorDesc in
            self?.transactionErrorDesc(errorDesc)
        }.store(in: &cancellables)
    }
    // Update Layout
    private func updateLayout() {
        guard let interfaceOrientation = UIWindow.key?.windowScene?.interfaceOrientation else { return }
        stackContainerView.axis = interfaceOrientation.isLandscape ? .horizontal : .vertical
    }
    // Update View Layout
    private func updateViewLayout() {
        viewTransactionType.applyCornerRadius()
        viewTransactionTypeSelection.applyCornerRadius()
        viewTransactionValueSelection.applyCornerRadius()
        viewTransactionAmountSelection.applyCornerRadius()
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
    @IBAction func btnTapGesture(_ sender: UITapGestureRecognizer) {
        self.addTransactionViewModel.dismissSelected(isDismissing: false)
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
