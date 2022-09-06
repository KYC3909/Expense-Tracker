//
//  TransactionsListVC.swift
//  Expense Tracker
//
//  Created by Krunal on 30/8/22.
//

import UIKit

final class TransactionsListVC: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerContainerView: UIView!
    @IBOutlet private weak var headerViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet private weak var addContainerView: UIView!
    @IBOutlet private weak var lblExpense: UILabel!
    @IBOutlet private weak var lblIncome: UILabel!
    @IBOutlet private weak var lblBalance: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!

    private(set) var viewModel: TransactionsListViewModelProtocol!
    private var previousDeviceOrientation: UIDeviceOrientation = UIDevice.current.orientation

    override func viewDidLoad() { super.viewDidLoad()
        setupViews(); setupOrientation()
    }
    override func viewWillLayoutSubviews() { super.viewWillLayoutSubviews()
        self.updateLayout()
    }
    private func setupViews() {
        progressView.setProgress(0, animated: true)

        headerContainerView.cardView(.appstore)
        headerViewWidthConstraint.constant = self.tableView.frame.width
        tableView.tableHeaderView = headerView
        
        addContainerView.cardView(.appstore)
        addContainerView.cornerRadius = addContainerView.frame.width / 2.0
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0,
                                                   bottom: self.view.frame.height - addContainerView.frame.minY,
                                                   right: 0)
        self.viewModel.fetchTransactionsList()
    }

    private func setupOrientation() {
        NotificationCenter.default.addObserver(
                self,
                selector:  #selector(self.deviceDidRotate),
                name: UIDevice.orientationDidChangeNotification,
                object: nil)
    }
    
    func assignViewModel(_ viewModel: TransactionsListViewModelProtocol)  {
        self.viewModel = viewModel
    }
    
    @IBAction func btnAddSelected(_ sender: UIButton) {
        self.viewModel.addTransactionSelected()
    }
    
    @objc func deviceDidRotate() {
        if UIDevice.current.orientation == previousDeviceOrientation { return }
        previousDeviceOrientation = UIDevice.current.orientation
        self.updateLayout()
    }
    private func updateLayout() {
        headerViewWidthConstraint.constant = self.tableView.frame.width
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Helper Methods
extension TransactionsListVC {
    
    // Add Transactions to the Table
    private func addTransactionsToTable(_ indexPaths: [IndexPath]) {
        
        // Check if Records are more than 1
        // [0] : Date
        // [1] : Cell View Model -> 'TransactionsListCellViewModel'
        if indexPaths.count > 1 {
            self.tableView.beginUpdates()
            self.tableView.performBatchUpdates({ [weak self] in
                self?.tableView.insertSections(IndexSet(integer: indexPaths[0].section), with: .automatic)
            })
            self.tableView.endUpdates()
        } else {
            self.tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    private func deleteTransactionsFromTable(_ indexPaths: [IndexPath]) {
        if indexPaths.count > 1 {
            self.tableView.beginUpdates()
            self.tableView.performBatchUpdates({ [weak self] in
                self?.tableView.deleteSections(IndexSet(integer: indexPaths[0].section), with: .automatic)
            })
            self.tableView.endUpdates()
        } else {
            self.tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    private func updateHeaderContent() {
        lblExpense.text = self.viewModel.transactionsTotalViewModel?.totalExpenseString
        lblIncome.text = self.viewModel.transactionsTotalViewModel?.totalIncomeString
        lblBalance.text = self.viewModel.transactionsTotalViewModel?.totalBalanceString
        progressView.setProgress(self.viewModel.transactionsTotalViewModel?.totalProgress ?? 0, animated: true)
    }
}

// MARK: - TransactionsListViewProtocol
extension TransactionsListVC: TransactionsListViewProtocol{
    
    func transacationAdditionDeletionSuccessful(_ indexPaths: [IndexPath], _ type: Transaction_CRUD_Type) {
        DispatchQueue.main.async { [weak self] in
            switch type {
                case .added:  self?.addTransactionsToTable(indexPaths)
                case .deleted: self?.deleteTransactionsFromTable(indexPaths)
            }
            self?.updateHeaderContent()
        }
    }
    func transacationsListFetchedSuccessful() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.updateHeaderContent()
        }
    }
    func transacationsListFetchedFailed(with error: String) {
        debugPrint(error)
    }
}
extension TransactionsListVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.viewModel.viewModelFor(indexPath)
        return TransactionsListCell.cellFor(tableView, at: indexPath, for: vm)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.viewModel.canDeleteRow(indexPath)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return self.viewModel.canDeleteRow(indexPath) ? .delete : .none
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { [weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            self?.viewModel.deleteItemFor(indexPath)
        })
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
