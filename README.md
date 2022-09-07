## Overview

Expense Tracker is a simple yet powerful animations written in Swift.

## Features

Expense Tracker loads Expenses or Income from Local Data Storage *CoreData*.

- CoreData Manager assigns work to Worker
- Added CoreData Worker for Adding/Deleting records from the Local Data Storage
- CoreData Worker also calculate the Total Expenses, Income while first time fetching the transactions from the Local Storage
- All the entries are displayed inside a separate section of UITableView using Grouped layout
- First Row of each section is non-deletable, It shows the Locale Date only. E.g. Sep 2, 2022
- Protocols added whenever required such as ViewModel, Local Data Storage, ViewProtocol, Coordinator Protocol and many more
- Use MVVM-C (Coordinator) architecture pattern
- Use Factory design pattern for PersistanceStoreContainer, ChildCoordinator
- Use Enum for TransactionType, PersistanceStore Name, CRUD Type, ChildCoordinator, and many more
- Created ViewModels for HeaderView, UITableViewCell, AddTransaction Screen
- Working with Dependency Injections 
- Follow SOLID Principles such as Validation classes follows Single Responsibility Principle, Open-Closed Principle, Interface Segregation Principle, Dependency Inversion Principle
- Write Test Cases

### Add Transaction
- Newest entry will be listed as First Row/Section
- Newest entry will be added using TableViewRowAnimation and perform Batch Updates

### Validations while adding Transaction
- Maximum amount is set to 100_000_000 (One Hundred Million)
- Minimum amount is set to 0
- If Transaction Type not selected like Expense/Income
- Display error message on screen when press `Add` button 

### Delete Transaction
- Swipe to Delete the record feature is available
- Deleted record will be animated via TableViewRowAnimation and perform Batch Updates
- Whole section will be deleted when only one record is there under the section other than first row

### App Walkthrough
| Light Mode | Dark Mode |
| --- | --- |
| ![LightMode](https://user-images.githubusercontent.com/7498229/188801813-4a300940-ebd2-46e1-a6e8-53d446c98610.gif) | ![DarkMode](https://user-images.githubusercontent.com/7498229/188802560-626e138b-ada5-4a3f-95d8-4cf91a2a7ddb.gif) |
