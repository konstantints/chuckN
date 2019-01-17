# ChuckN

Open source app for get ~~jokes~~ facts about Chuck Norris. All facts get from [chucknorris.io](https://api.chucknorris.io).

## Getting started

1. [Download](https://developer.apple.com/xcode/download/) the Xcode 10 release.
2. Clone this repository
3. Run project
4. Enjoy!!!

### The little bit about the app architecture.

- One storyboard - one workflow. Easy to change the app flow and no more the merge conflicts.
- All data are cached in the Realm database
- For network requests - Alamofire
- SwiftyJSON for JSON
- Helps stay the code in order - SwiftLint
- Organize resources with SwiftGen