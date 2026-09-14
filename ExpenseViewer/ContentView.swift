//
//  ContentView.swift
//  ExpenseViewer
//
//  Created by SAIKUMAR PALLAGANI on 14/09/26.
//

import Expense
import SwiftUI

struct ContentView<API: ExpenseAPI>: View {
    let expenseAPI: API

    var body: some View {
        expenseAPI.makeExpenseListView()
    }
}
