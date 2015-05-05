# Errata for Cocoa Programming for OS X, 5th Edition

If you encounter issues in the book, please post them to the forum for the appropriate chapter at [forums.bignerdranch.com][forum]. Thank you!

[forum]: http://forums.bignerdranch.com/viewforum.php?f=511


### 3. Structures and Classes

- In the section "Reference and Value Types", `ball0.particle.x = 1` should be `ball0.position.x = 1`.

### 8. KVC, KVO, and Bindings

- In the For the More Curious section on Dependent Keys, the class `Person` has two problems: First, as documented earlier in the chapter, a class must subclass NSObject to participate in KVO. Thus, Person should subclass NSObject. Second, the computed property `fullName` must have the explicit type `String`.

### 14. User Defaults

- In the section Storing the User Defaults, the text says that "you will need to make the app delegate the delegate of the text field". As shown correctly in the code listing that follows, it is the main window controller that should be the delegate of the text field. Later, the text says to open `MainMenu.xib`. Instead, you should open `MainWindowController.xib`.

### 27. Printing

- In `EmployeesPrintingView`, the `init?(coder:)` initializer calls `assertionFailure()`. This should be changed to `fatalError()`. The reason is that with optimization enabled, such as in a release build, the compiler leaves out assertions. The Swift compiler knows this and in order to ensure that an object is fully initialized, considers it an error. Calls to `fatalError()` are not ignored, however.


### 29. Unit Testing

- In the section "Refactoring for Testing" where the contents of `fetchCoursesUsingCompletionHandler(_:)` is cut and pasted to `resultFromData(_:response:error:)`, the line `result = .Success([])` should read `result = self.resultFromData(data)`. Cutting and pasting avoids this problem.
