# Errata for Cocoa Programming for OS X, 5th Edition

If you encounter bugs in the book, please post them to the [forums][forum].

[forum]: http://forums.bignerdranch.com/viewforum.php?f=511


### 27. Printing

- In `EmployeesPrintingView`, the `init?(coder:)` initializer calls `assertionFailure()`. This should be changed to `fatalError()`. The reason is that with optimization enabled, such as in a release build, the compiler leaves out assertions. The Swift compiler knows this and in order to ensure that an object is fully initialized, considers it an error. Calls to `fatalError()` are not ignored, however.


### 29. Unit Testing

- In the section "Refactoring for Testing" where the contents of `fetchCoursesUsingCompletionHandler(_:)` is cut and pasted to `resultFromData(_:response:error:)`, the line `result = .Success([])` should read `result = self.resultFromData(data)`. Cutting and pasting avoids this problem.
