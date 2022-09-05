//
//  TransactionsListCell.swift
//  Expense Tracker
//
//  Created by Krunal on 31/8/22.
//

import UIKit

class TransactionsListCell: UITableViewCell {
    static let id = "TransactionsListCell"
    
    // Outlets
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var lblAmount: UILabel?

    override func awakeFromNib() { super.awakeFromNib()
    }
}

extension TransactionsListCell {
    
    static func cellFor(_ tableView: UITableView, at indexPath: IndexPath, for vm: TransactionsListCellViewModel) -> TransactionsListCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsListCell.id, for: indexPath) as! TransactionsListCell
        cell.configure(vm)
        return cell
    }
    
    func configure(_ vm: TransactionsListCellViewModel) {
        selectionStyle = vm.editable ? .default : .none
        lblTitle?.text = vm.transactionTitle
        lblAmount?.text = vm.transactionAmount
        
//        isEditing = true
    }
}
