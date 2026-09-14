//
//  ExpenseViewerApp.swift
//  ExpenseViewer
//
//  Created by SAIKUMAR PALLAGANI on 14/09/26.
//

import SwiftUI

@main
struct ExpenseViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(expenseAPI: AppCompositionRoot.expenseAPI)
        }
    }
}
