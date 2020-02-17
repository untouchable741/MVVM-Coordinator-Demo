# GitHubUsersDemo
## Installations
In the repo's root folder, run :
```
pod install
```
## Requirements
- Xcode 11+
- Swift 5+

## Highlights
- [x] Main architecture is MVVM-Coordinator pattern.
- [x] [RxSwift](https://github.com/ReactiveX/RxSwift) as the core framework for asynchronouse task handling and data binding.
- [x] Apply Protocol-oriented programing and dependencies injection for easier mocking/stubbing in writting unit testing.
- [x] [Mockingjay](https://github.com/kylef/Mockingjay) as network stubbing library for unit testing.
- [x] Utilized swift 5 new features (propertyWrapper, stringInterpolation).
- [x] Unit Testing
- [ ] UI Testing

## Descriptions
This is demo application showing list of users from github users API: 
- Fetch and present users from github.com.
- Handle various UI state (blank, loading, partial, error).
- Display network activity to the user.
- Paginate or batch requests for remote Github users in response to user
interaction.
- Respect the iOS Dynamic Type settings of the user.
- Allow adding and remove user from favorite list (store locally).
