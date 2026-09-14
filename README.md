# ExpenseViewer

An iOS 17+ SwiftUI application that retrieves expenses through an Objective-C networking stack and displays them newest first.

## Architecture

The application uses two local Swift packages as its compile-time module boundaries. The architectural layers inside
`Expense` are folders within that single module:

```text
ExpenseViewer app (composition root)
├── Expense package/module
│   ├── Expense (public ExpenseAPI + ExpenseAPIClient)
│   ├── ExpensesPresentation (SwiftUI + view model)
│   ├── ExpensesDomain (entities, repository contract, use case)
│   └── ExpensesData (repository implementation and DTO mapping)
└── Network package/module (Objective-C)
    ├── Core (generic GET/POST transport and network errors)
    └── ExpenseRemote (JSON parser, DTO and service factory)
```

`Network` is one fully Objective-C module. Its `Core` folder is domain-agnostic, while `ExpenseRemote` transforms raw JSON into typed Objective-C DTOs. `Expense` is one Swift module with a public `ExpenseAPI` contract, its `ExpenseAPIClient` implementation, and Domain, Data, and Presentation folders kept as internal architectural layers.

The app links and imports only the `Expense` product. The `Expense` module imports its single dependency using `import Network`.

## Design decisions

- The app target is the composition root.
- The app implements the Network-owned `NetworkConfiguration` protocol and supplies only a base URL and timeout.
- The expense endpoint path is owned by Expense, not by the app or generic network layer.
- `ExpenseAPIClient` also provides a generic network-client injection initializer for deterministic mocks without using `any`.
- Factories construct concrete networking dependencies.
- `EVExpensesServicing` is the remote facade.
- `ExpenseRepository` is owned by Domain and implemented by Data.
- The use case applies newest-first ordering.
- The view model exposes a single state machine: idle, loading, loaded, empty, or failed.
- No singleton or third-party dependency is used.
- Money uses `Decimal`/`NSDecimalNumber` rather than binary floating point.

## Expected API contract

The parser accepts either a top-level array or `{ "expenses": [...] }` / `{ "data": [...] }`. Each expense requires a title, amount, and date:

```json
[
  {
    "id": "expense-1",
    "title": "Train ticket",
    "amount": "18.75",
    "currency": "USD",
    "date": "2026-09-13T10:30:00Z"
  }
]
```

For compatibility with the unavailable sample endpoint, the parser also recognizes common aliases such as `name`, `description`, `expenseDate`, and `createdAt`. Missing IDs receive a deterministic index-based identifier, and missing currencies default to USD.

## Running

1. Open `ExpenseViewer.xcodeproj`.
2. Select the `ExpenseViewer` scheme and an iOS 17+ simulator.
3. Build and run.

`AppNetworkConfiguration` supplies the API base URL, `https://www.jsonkeeper.com`, while the Expense package owns the
feature path, `/b/DYZJF`.

## Tests

Run the package suites independently:

```sh
cd Packages/Network && swift test
cd Packages/Expense && swift test
```

The tests cover GET/POST request construction, HTTP and transport failures, Objective-C JSON transformation, DTO mapping, domain ordering, and presentation states. The Xcode scheme also includes an app integration test and a root-screen UI test.
