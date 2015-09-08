# Errata for Cocoa Programming for OS X, 5th Edition

If you encounter issues in the book, please post them to the forum for the appropriate chapter at [forums.bignerdranch.com][forum]. Thank you!

[forum]: http://forums.bignerdranch.com/viewforum.php?f=511


### 2. Swift Types

- `countingUp` should be defined as a variable (and not a constant) in the section Literals and Subscripting: `var countingUp = ...`. This is necessary because it is later mutated when calling `countingUp.append("three")` in the Instance methods section.

### 3. Structures and Classes

- In the section "Reference and Value Types", `ball0.particle.x = 1` should be `ball0.position.x = 1`.

### 6. Delegation

- The `speechSynthesizer(_:didFinishSpeaking:)` method is correctly implemented to set `isStarted = false`. However, later in the chapter the same method is incorrectly shown to call `updateButtons()` instead.
- In the section "Common errors in implementing a delegate", the description of buggy behavior upon misspelling `speechSynthesizer(_:didFinishSpeaking:)` should state that the Start button will never be enabled (the Stop button remains enabled indefinitely). Additionally, the window can not be closed.

### 8. KVC, KVO, and Bindings

- In the For the More Curious section on Dependent Keys, the class `Person` has two problems: First, as documented earlier in the chapter, a class must subclass NSObject to participate in KVO. Thus, Person should subclass NSObject. Second, the computed property `fullName` must have the explicit type `String`.

### 14. User Defaults

- In the section Storing the User Defaults, the text says that "you will need to make the app delegate the delegate of the text field". As shown correctly in the code listing that follows, it is the main window controller that should be the delegate of the text field. Later, the text says to open `MainMenu.xib`. Instead, you should open `MainWindowController.xib`.

### 18. Mouse Events

- In the section Improving Hit Detection, the `pressed` property is used to indicate whether the user actually clicked on the die. The `mouseUp(_:)` method (from the previous section entitled Click to Roll), however, does not check `pressed` before calling `randomize()`. As such the if expression in `mouseUp(_:)` should read: `theEvent.clickCount == 2 && pressed`.

### 25. Auto Layout

- In the section on Ambiguous Layout, on page 375, the reader is instructed to add a call to `visualizeConstraints(_:)` at the end of `applicationDidFinishLaunching(_:)`. The line above, shown for context, is a call to `addConstraints(_:)`, but it should be `NSLayoutConstraint.activateConstraints(verticalConstraints)`.  `addConstraints(_:)` is the old way of doing this; it has been noted as deprecated in Apple's headers.

### 27. Printing

- In `EmployeesPrintingView`, the `init?(coder:)` initializer calls `assertionFailure()`. This should be changed to `fatalError()`. The reason is that with optimization enabled, such as in a release build, the compiler leaves out assertions. The Swift compiler knows this and in order to ensure that an object is fully initialized, considers it an error. Calls to `fatalError()` are not ignored, however.

### 28. Web Services

- In the code snippet demonstrating using `NSXMLDocument` the result of the calls to `nodesForXPath(_:error:)`, is cast using `as [NSXMLNode]`. Because the type of this API presently returns `[AnyObject]!`, in the eyes of the Swift compiler this cast could fail. As such it must be cast using `as!`, like this: `nodesForXPath(...) as! [NSXMLNode]`.

- In `ScheduleFetcher`, the `courseFromDictionary(_:)` method instantiates an `NSDateFormatter` and assigns a var to reference it: `var dateFormatter = NSDateFormatter()`.  The `dateFormatter` reference should never be changed to refer to a different object, so it should be a `let` instead: `let dateFormatter = NSDateFormatter()`.

- In `ScheduleFetcher`, the same error code (`1`) is used twice.  There should be a different error code for each type of error.  The error code for the second error ("Bad status code") should have code `2`: `let error = self.errorWithCode(2, localizedDescription: "Bad status code \(response.statusCode)")`.

### 29. Unit Testing

- In the section "Refactoring for Testing" where the contents of `fetchCoursesUsingCompletionHandler(_:)` is cut and pasted to `resultFromData(_:response:error:)`, the line `result = .Success([])` should read `result = self.resultFromData(data)`. Cutting and pasting avoids this problem.
