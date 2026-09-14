//
//  ExpenseViewerTests.swift
//  ExpenseViewerTests
//
//  Created by SAIKUMAR PALLAGANI on 14/09/26.
//

import Foundation
import Testing
@testable import ExpenseViewer

struct ExpenseViewerTests {

    @MainActor
    @Test func productionConfigurationUsesExpectedBaseURL() {
        #expect(AppNetworkConfiguration().baseURL.absoluteString == "https://www.jsonkeeper.com")
    }

}
