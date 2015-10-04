# Swift 2 Companion Guide for Cocoa Programming for OS X

The 5th edition of Cocoa Programming for OS X: The Big Nerd Ranch Guide was written for Xcode 6.3 and Swift 1.2. At WWDC 2015, Apple announced Xcode 7 and Swift 2, both of which introduce significant updates. Those changes, and to a lesser extent changes to Cocoa for OS X 10.11, necessitate this companion guide for using Xcode 7 to work through the exercises in the book.

If you have old projects written in Swift 1.2 using Xcode 6, when you open them in Xcode 7 you will be presented with a dialog that will help you migrate your project to the latest version of Swift. This migration, while very helpful, is not bulletproof. This guide will answer any questions which are not covered by the migration tool. For additional discussion, join us on the [Big Nerd Ranch forums](http://forums.bignerdranch.com/viewforum.php?f=520).

The exercise solutions have been updated for Swift 2 as well.  They are [available here](../..).  If you are still working with Swift 1.2, those solutions are [still available](../../tree/swift1-2).

### Common Changes

The following changes are broad enough to affect numerous chapters:

In Swift 2, `println()` is now `print()`. Any calls to `println()` must be changed to call `print()`, which has the same result.

Swift 2 introduces a new mechanism for handling errors, using the `throw` and `throws` keywords. Although it superficially resembles exception handling used in other languages, its operation is very similar to Cocoa's existing error handling mechanism, with the addition of compiler enforcement of the convention. Detailed changes are listed by chapter below.

Swift 2 replaces a number of free functions with methods (generally from protocol extensions). For example, the free function `enumerate(_:)` has been replaced with a method `enumerate()` on `SequenceType`. Any calls to these free functions must be replaced with calls to the corresponding methods, which have the same result. Detailed changes are listed by chapter below.

### Chapter 1. Let's Get Started

p. 23: In Swift 1.2, an `Array<Character>` could be created by initializing an `Array` with a string. This makes some assumptions about the encoding of the components of the string, and in Swift 2 this must now be written as follows:

    private let characters = Array(("0123456789abcdefghijklmnopqrstuvwxyz" +
                                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ").characters)

As of this writing the type of `characters` is `Array<_Element>`, which may be a Swift bug since `_Element` is presumably a private type. In practice it behaves as an `Array<Character>`.

p. 23: Xcode 7 also warns about the for loop in `generateRandomString(_:)`, since `index` is not used. You can silence this warning by using an `_` in place of the unused variable:

    for _ in 0..<length {


### Chapter 2. Swift Types

p. 37: The Swift 1.2 free function `enumerate()` was used to enumerate the members of `countingUp`. In Swift 2 this has been changed from a free function to a method, and you instead call it on the array:

    for (i, string) in countingUp.enumerate() {


### Chapter 3. Structures and Classes

p. 54: `Printable` has been renamed to `CustomStringConvertible`. To allow printing of the type `Vector`, make it conform to this new protocol:

    struct Vector: CustomStringConvertible {


### Chapter 7. Table Views

p. 122: `availableVoices()` has been updated thanks to Objective-C generics and now returns `[String]`, so no forced cast (`as! [String]`) is needed:

    let voices = NSSpeechSynthesizer.availableVoices()

p. 123: `attributesForVoice(_:)` no longer returns an optional dictionary, so the if-let structure is unnecessary. Instead, you can simply assign the attributes dictionary and return the optional value from the dictionary:

    let attributes = NSSpeechSynthesizer.attributesForVoice(voice)
    return attributes[NSVoiceName] as? String

p. 133: `find()` is no longer available as a free function. It is now `CollectionType.indexOf(_:)`:

    if let defaultRow = voices.indexOf(defaultVoice) {


### Chapter 8. KVC, KVO, and Bindings

p. 155: The signature for `observeValueForKeyPath(_:ofObject:change:context:)` has changed. The first three parameters are now optionals, not implicitly unwrapped optionals. Furthermore, the third parameter's type is now `[String: AnyObject]?`.

p. 155: It is now easier to specify dependent keys. The return type of a class method named `keyPathsForValuesAffecting####` is now `Set<String>`. Furthermore, it is no longer necessary to specify the type returned; the array literal syntax is inferred to define a `Set`. The example implementation of `keyPathsForValuesAffectingFullName()` is now

    class func keyPathsForValuesAffectingFullName() -> Set<String> {
        return ["firstName", "lastName"]
    }


### Chapter 9. NSArrayController

p. 159-160: With Swift 2's new `throw` keyword for error handling, the signatures of the `dataOfType(_:error:)` and `readFromData(_:ofType:error:)` methods have changed to `dataOfType(_:)` and `readFromData(_:ofType:)`. The new project template's `Document` class will be implemented to call `throw NSError(...)`. Instead of removing these lines as shown in the book, leave them as-is. You may see an error message related to auto-saving, which can be ignored until the Archiving chapter.

p. 177: `NSPredicate`'s initializer is no longer failable, so the if-let is unnecessary. If the predicate format string is invalid, the application will trap (programmer error). Also, the result of `filteredArrayUsingPredicate(_:)` must be force-cast (using `as!`) to `[Employee]`.

    let employeesArray = employees as NSArray
    let formatString = "name like[c] %@ and raise > 0.0"
    let compoundPredicate = NSPredicate(format: formatString, someName)
    let matches =
          employeesArray.filteredArrayUsingPredicate(compoundPredicate) as! [Employee]

### Chapter 10. Formatters and Validation

p. 185-186: Again, with the `throw` keyword, the signature for the key-value validation method has changed under Swift 2. The complete method body is now as follows:

    func validateRaise(raiseNumberPointer:
           AutoreleasingUnsafeMutablePointer<NSNumber?>) throws {
        let raiseNumber = raiseNumberPointer.memory
        if raiseNumber == nil {
            let domain = "UserInputValidationErrorDomain"
            let code = 0
            let userInfo = [NSLocalizedDescriptionKey : "An employee's raise must be a number."]
            throw NSError(domain: domain, code: code, userInfo: userInfo)
        }
    }


### Chapter 11. Undo

p. 198: The signature for `observeValueForKeyPath(_:ofObject:change:context:)` now has optional parameters for `keyPath`, `object`, and `change`. There are three ways to deal with this:

- Keep using the implicitly unwrapped optionals in the signature, as shown in the book.
- Force-unwrap them upon each use within the method.
- Unwrap them safely by using conditional unwrapping: 
    `if let keyPath = keyPath, object = object, change = change {`

For safety and overall clarity we recommend using the last option. 

Regardless of the option chosen here, the type of the `change` dictionary will need to be updated. In OS X 10.11, this change dictionary is now recognized to have string keys; as a result, the parameter's type is `[String: AnyObject]?`.

p. 201: The `windowControllers` property on `NSDocument` is now of type `[NSWindowController]`, so no forced cast (`as! NSWindowController`) is necessary.

p. 201: When assigning `row`, `find(sortedEmployees, employee)!` is now `sortedEmployees.indexOf(employee)!`.


## Chapter 12. Archiving

p. 206: The `NSCoding` initializer `init(coder:)` has changed to be failable. As such, the signature used in the `Employee` class now begins as follows (note the `init?`):

    required init?(coder aDecoder: NSCoder) {

p. 208+: As mentioned earlier, Swift 2 adds [new features for error handling](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ErrorHandling.html), so some of the method signatures shown in the text have changed. The methods `dataOfType(_:)` and `readFromData(_:ofType:)` on `Document` now read:

    override func dataOfType(typeName: String) throws -> NSData {
        tableView.window!.endEditingFor(nil)
        return NSKeyedArchiver.archivedDataWithRootObject(employees)
    }
    
    override func readFromData(data: NSData, ofType typeName: String) throws {
        employees = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Employee]
    }


## Chapter 16. Notifications

p. 264: With the latest SDK, accessing the `window` property on an instance of `AnyObject` is not allowed. In the `ChatWindowController`'s `send(_:)` method, change the type of the `sender` parameter from `AnyObject` to the more specific `NSButton`:

    @IBAction func send(sender: NSButton) {

An alternative solution, preferable if for some reason you did not know the type of `sender`, would be to use `if-let` to safely cast `sender` to `NSButton`.


## Chapter 17. NSView and Drawing

p. 282: Swift 2 simplifies the rules for the naming of function and method parameters: all parameters after the first are, by default, named. Previously, this only applied to methods and not to functions. As such, the `drawDot` function's signature must be changed to make the second parameter unnamed, using an underscore ( `_` ):

        func drawDot(u: CGFloat, _ v: CGFloat) {

p. 282: The method for obtaining a new `CGRect` inset from an existing `CGRect` has been renamed from `rectByInsetting(dx:dy:)` to `insetBy(dx:dy:)`. This affects the implementatation of `metricsForSize(_:)` and `drawDot(_:_:)` in `DieView`.

p. 283: Additionally, because the `find()` function is no longer available, you must use the `indexOf(_:)` method to check for `intValue`'s membership in the arrays and ranges:

    if (1...6).indexOf(intValue) != nil {
        // Draw the dots:
        if [1, 3, 5].indexOf(intValue) != nil {
            drawDot(0.5, 0.5) // Center dot
        }
        if (2...6).indexOf(intValue) != nil {
            drawDot(0, 1) // Upper left
            drawDot(1, 0) // Lower right
        }
        if (4...6).indexOf(intValue) != nil {
            drawDot(1, 1) // Upper right
            drawDot(0, 0) // Lower left
        }
        if intValue == 6 {
            drawDot(0, 0.5) // Mid left/right
            drawDot(1, 0.5)
        }
    }

## Chapter 18. Mouse Events

p. 300: The method for obtaining a new `CGRect` offset from an existing `CGRect` has been renamed from `rectByOffsetting(dx:dy:)` to `offsetBy(dx:dy:)`. This affects the implementation of `metricsForSize(_:)` in `DieView`.

## Chapter 19. Keyboard Events

p. 308: In `insertText(_:)`, instead of using `toInt()`, which is no longer available, use the failable initializer for `Int`:

    if let number = Int(text) {


## Chapter 20. Drawing Text

p. 317: In `drawDieWithSize(_:)`, when setting `paraStyle.alignment`, the enum value name has changed from `CenterTextAlignment` to `Center`.

p. 318: The `NSString` method `sizeWithAttributes(_:)` now takes an optional `[String: AnyObject]` dictionary. Change the signature for `drawCenteredInRect(_:attributes:)` to match:

    func drawCenteredInRect(rect: NSRect, attributes: [String: AnyObject]?) {

p. 319: In `savePDF(_:)`, the call to `writeToURL(_:options:)` must be changed to account for Swift 2's error handling:

    savePanel.beginSheetModalForWindow(window!) {
        [unowned savePanel] (result) in
        if result == NSModalResponseOK {
            let data = self.dataWithPDFInsideRect(self.bounds)
            do {
                try data.writeToURL(savePanel.URL!,
                           options: NSDataWritingOptions.DataWritingAtomic)
            } catch let error as NSError {
                let alert = NSAlert(error: error)
                alert.runModal()
            } catch {
                fatalError("unknown error")
            }
    	}
    }


## Chapter 21. Pasteboards and Nil-Targeted Actions

p. 326: In `readFromPasteboard(_:)`, when setting `intValue` to a new value, use the failable `Int` initializer instead of `toInt()`.


## Chapter 22. Drag-and-Drop

p. 337: In the book, `draggingSession(_:sourceOperationMaskForDraggingContext:)` is written to return `.Copy | .Delete`. In Swift 2 this is most cleanly expressed using an array literal of the cases to be combined. The array literal is implicitly converted to an `NSDragOperation`:

    return [.Copy, .Delete]

p. 338: The initializer for `NSGradient` that is used is now failable. As such you must now force-unwrap the value returned. Another option is to use an `if-let` to gracefully fall back to some other behavior. As this code is written, however, it is unlikely that it would fail to create an `NSGradient` unless there were some programmer error.

p. 336: As you saw in the changes for Chapter 18 (Mouse Events), the method `CGRect.rectByOffsetting(dx:dy:)` has been renamed to `CGRect.offsetBy(dx:dy:)`. Since `NSRect` is just a typealias for `CGRect`, this change affects the methods on `NSRect` as well. This alters the implementation of `mouseDragged(_:)` in `DieView`:

    let draggingFrame = NSRect(origin: draggingFrameOrigin, size: imageSize)
            .offsetBy(dx: -imageSize.width/2, dy: -imageSize.height/2)

## Chapter 25. Auto Layout

p. 372: In the section of the chapter where the AutoLabelOut app is created, the content view of the window is accessed and used (as a view). Prior to OS X 10.11, the type of the `contentView` property on `NSWindow` was `AnyObject`; in 10.11, the type has been updated to be `NSView?`. As a result, it is no longer necessary to force-cast to `NSView`, but you must force-unwrap it:

    let superview = window.contentView!

p. 372: In the same section, the method `constraintWithVisualFormat(_:options:metrics:views:)` is used to create vertical constraints. You want to specify no options for the second argument. In Swift 1.2, this was done by using `.allZeros`. In Swift 2, it is expressed using an empty array literal `[]` (as was done in the Swift 2 changes for Drag-and-Drop):

    let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[textField]-|",
        options:[],
        metrics:nil,
        views: ["textField" : textField])

p. 372: In AutoLabelOut, the static method on `NSRect` (in fact, on `CGRect`, which `NSRect` is a typealias for) that yields the rect whose fields are all `0.0` has been renamed from `zeroRect` to `zero`. This affects the implementation of `applicationDidFinishLaunching(_:)` in `AppDelegate`.

## Chapter 26. Localization

p. 385: When stating the signature of the `NSLocalizedString` function, the book decorates the second argument with a `#`. In Swift 2, there is a uniform convention for external names of functions and methods. As a result, the function signature is now expressed without that character:

    NSLocalizedString(key: String, comment: String) -> String

p. 393: Swift 2 improvements have simplified plugin loading. The sample code for doing so is now:

    if let roverClass = niftyBundle.principalClass as? Rover.Type {
        let rover = roverClass.init()
        rover.fetch()
    }

## Chapter 27. Printing

p. 397, p. 401: As part of Swift 2's new error handling features, some method signatures shown in the text have changed. The `Document` class method `printOperationWithSettings(_:)` now reads:

    override func printOperationWithSettings(printSettings: [String : AnyObject]) throws -> NSPrintOperation {
        let employeesPrintingView = EmployeesPrintingView(employees: employees)
        let printInfo: NSPrintInfo = self.printInfo
        let printOperation = NSPrintOperation(view: employeesPrintingView, printInfo: printInfo)
        return printOperation
    }

p. 403: At the end of the chapter, `Document`'s method `readFromData(_:ofType:)` is discussed. As mentioned above in the updates to chapter 12 (Archiving), the signature of this method has changed:

    override func readFromData(data: NSData, ofType typeName: String) throws

## Chapter 28. Web Services

p. 409: As part of the continuing auditing of the Cocoa API, the method signature for `NSURLSession.dataTaskWithRequest(_:completionHandler:)` has changed. It is now

    func dataTaskWithRequest(request: NSURLRequest, 
                   completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void)
                                   -> NSURLSessionDataTask

This signature change affects the implementation of `ScheduleFetcher.fetchCoursesUsingCompletionHandler(_:)`, as you will see in a moment.

p. 416: As part of the error handling changes in Swift 2, `NSJSONSerialization.JSONObjectWithData(_:options:)` now throws. The natural way to handle this is to replace the method `resultFromData(_:)` with a new method `coursesFromData(_:)`:

    func coursesFromData(data: NSData) throws -> [Course] {
        let topLevelDict = try NSJSONSerialization.JSONObjectWithData(data,
                                                             options: [])
                               as! NSDictionary
        
        let courseDicts = topLevelDict["courses"] as! [NSDictionary]
        var courses: [Course] = []
        for courseDict in courseDicts {
            if let course = courseFromDictionary(courseDict) {
                courses.append(course)
            }
        }
        return courses
    }

p. 411: Rather than returning a `FetchCoursesResult`, this new method throws if an error occurs and otherwise returns an instance of `[Course]`. This boxes up the same information as the result. In order to call the completion from `fetchCoursesUsingCompletionHandler(_:)` and use `coursesFromData(_:)`, you need to be able to create an instance of `FetchCoursesResult` from a method that returns `[Course]` or throws. To do that, add the following initializer:

    init(throwingClosure: () throws -> [Course]) {
        do {
            let courses = try throwingClosure()
            self = .Success(courses)
        }
        catch {
            self = .Failure(error as NSError)
        }
    }

p. 412, p. 414: To handle the preceding three changes, change the `fetchCoursesUsingCompletionHandler(_:)` method as follows:

    func fetchCoursesUsingCompletionHandler(completionHandler: FetchCoursesResult -> Void) {
        let url = NSURL(string: "http://bookapi.bignerdranch.com/courses.json")!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            let result: FetchCoursesResult
            
            if let data = data {
                if let response = response as? NSHTTPURLResponse {
                    print("\(data.length) bytes, HTTP \(response.statusCode).")
                    if response.statusCode == 200 {
                        result = FetchCoursesResult { try self.coursesFromData(data) }
                    }
                    else {
                        let error = self.errorWithCode(2, localizedDescription: "Bad status code \(response.statusCode)")
                        result = .Failure(error)
                    }
                }
                else {
                    let error = self.errorWithCode(1, localizedDescription: "Unexpected response object.")
                    result = .Failure(error)
                }
            }
            else {
                result = .Failure(error!)
            }
        
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completionHandler(result)
            }
        }
        task.resume()
    }

p. 420: Finally, the error handling changes in Swift 2 simplify the XML parsing in the section "For the More Curious: Parsing XML". Now, rather than checking for `nil` and passing an error reference to be written into, you will use a `do` block and `try` each failable operation:

    let xmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        + "<people>"
        + "  <person><first>Jimmy</first><last>Smith</last></person>"
        + "  <person><first>Lonnie</first><last>Smith</last></person>"
        + "</people>"
    
    do {
        let doc = try NSXMLDocument(XMLString: xmlString, options: 0)
        let people = try doc.nodesForXPath("//person")
        for person in people {
            let firstNameNodes = try person.nodesForXPath("first")
            if let firstNameNode = firstNameNodes.first {
                print(firstNameNode.stringValue!)
            }
        }
    }
    catch {
        print(error)
    }

## Chapter 29. Unit Testing

p. 432: As you saw in the notes for Chapter 28 (Web Services), the signature of the closure accepted by `NSURLSession.dataTaskWithRequest(_:completionHandler:)` has changed. This change makes it natural to change the types accepted by `ScheduleFetcher.resultFromData(_:response:error:)` as follows:

    public func resultFromData(data: NSData?, response: NSURLResponse?, error: NSError?)
                        -> FetchCoursesResult {

Combining the changes listed above to the Web Services chapter with the steps given in the Unit Test chapter yields the following implementation for `resultFromData(_:response:error:)`:

    public func resultFromData(data: NSData?, response: NSURLResponse?, error: NSError?)
                        -> FetchCoursesResult {
        let result: FetchCoursesResult
        
        if let data = data {
            if let response = response as? NSHTTPURLResponse {
                print("\(data.length) bytes, HTTP \(response.statusCode).")
                if response.statusCode == 200 {
                    result = FetchCoursesResult { try self.coursesFromData(data) }
                }
                else {
                    let error =
                    self.errorWithCode(2, localizedDescription:
                                          "Bad status code \(response.statusCode)")
                    result = .Failure(error)
                }
            }
            else {
                let error =
                self.errorWithCode(1, localizedDescription:
                                      "Unexpected response object.")
                result = .Failure(error)
            }
        }
        else {
            result = .Failure(error!)
        }
        
        return result
    }

p. 433: Similarly, the implementation for `fetchCoursesUsingCompletionHandler(_:)` has changed to:

    func fetchCoursesUsingCompletionHandler(completionHandler: FetchCoursesResult -> Void) {
        let url = NSURL(string: "http://bookapi.bignerdranch.com/courses.json")!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            let result: FetchCoursesResult
                = self.resultFromData(data, response: response, error: error)
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completionHandler(result)
            }
        }
        task.resume()
    }

p. 433: Finally, due to the error handling changes in Swift 2, the definition of `Constants.jsonData` is now:

    static let jsonData = try! NSJSONSerialization.dataWithJSONObject(coursesDictionary,
                                                             options: [])

Note that this is a safe operation. The object from which the JSON data is being created (`coursesDictionary`) is under the control of the test author; if `dataWithJSONObject(_:options:)` throws, it is due to a programmer error.

## Chapter 31. View Swapping and Custom Container View Controllers

p. 451: A few changes in Swift 2 and OS X 10.11 affect the implementation of `NerdTabViewController.selectTabAtIndex(_:)`:

1. The free function `contains(_:_:)` from Swift 1.2 has been replaced with the method `SequenceType.contains(_:)` on `SequenceType`.
2. The free function `enumerate(_:)` from Swift 1.2 has been replaced with the method `SequenceType.enumerate()` on `SequenceType`.
3. The `NSViewController` header has been audited so that the type of `NSViewController.childViewControllers` is now `[NSViewController]` rather than `[AnyObject]`. As a result, it is no longer necessary to cast elements of the array to that type.

These three changes combine to yield the following implementation of `selectTabAtIndex(_:)`:

    func selectTabAtIndex(index: Int) {
        let range = 0..<childViewControllers.count
        assert(range.contains(index), "index out of range")
        for (i, button) in buttons.enumerate() {
            button.state = (index == i) ? NSOnState : NSOffState
        }
        let viewController = childViewControllers[index]
        box.contentView = viewController.view
    }

p. 452-453: The method `NerdTabViewController.reset()` method is similarly affected:

1. As above, thanks to the auditing of `NSViewController`, the type of `childViewControllers` is now `[NSViewController]`, so it is not necessary to cast to `NSViewController` when accessing its elements.
2. The free function `map(_:_:)` has been replaced with the member function `SequenceType.map(_:)` on `SequenceType`.
3. As above, the free function `enumerate(_:)` has been replaced with the method `SequenceType.enumerate()`.

These three changes alter two lines of the implementation of `NerdTabViewController.reset()` from:

        let viewControllers = childViewControllers as! [NSViewController]
        buttons = map(enumerate(viewControllers)) {

to:

        let viewControllers = childViewControllers
        buttons = viewControllers.enumerate().map {

p. 453: Finally, the nested function `addVisualFormatConstraints(_:)` (within `NerdTabViewController.reset()`) is affected by two changes:

1. In the book, the `options` argument being passed to `NSLayoutConstraint.constraintsWithVisualFormat(_:options:metrics:views:)` is `.allZeros`. In Swift 2, this is no longer the correct way to specify "none of the options from the `NSLayoutFormatOptions` option set", as you already saw in the notes for Chapter 25 (Auto Layout). The correct way to specify this now is by using the empty array literal syntax (`[]`).
2. The preferred way to activate an array of `NSLayoutConstraint`s is now to call the class method `NSLayoutConstraint.activateConstraints(_:)` on `NSLayoutConstraint`.

These two changes yield the following updated implementation of the function `addVisualFormatConstraints(_:)` nested within `NerdTabViewController.reset()`:

            func addVisualFormatConstraints(visualFormat:String) {
                let constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
                options: [],
                metrics: metrics,
                views: views)
                NSLayoutConstraint.activateConstraints(constraints)
            }

## Chapter 32. Storyboards

p. 469: In OS X 10.11, the `NSSplitViewController` class has been audited and the type of `splitViewItems` is now `[NSSplitViewItem]` rather than `[AnyObject]`. This means that it is no longer necessary to cast to `NSSplitViewItem` when accessing the elements of the array. This allows you to remove the casts in `MainSplitViewController` in the implementations of the `masterViewController` and `detailViewController` properties:

    var masterViewController: CourseListViewController {
        return splitViewItems[0].viewController as! CourseListViewController
    }
    
    
    var detailViewController: WebViewController {
        return splitViewItems[1].viewController as! WebViewController
    }

p. 470: In OS X 10.11, the initializer `NSStoryboard(name:bundle:)` is no longer failable. If invalid arguments are provided, an Objective-C exception is thrown. This affects the code shown in the section "For the More Curious: How is the Storyboard Loaded?" as follows:

    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    if let vc = storyboard.instantiateControllerWithIdentifier("Palette") as? NSViewController {
            paletteWindow = NSWindow(contentViewController: vc)
            paletteWindow.makeKeyAndOrderFront(nil)
    }

## Chapter 33. Core Animation

p. 472: `CALayer` has now been audited for implicitly unwrapped optionals (IUOs) as well as other types. As a result, the listing of `CALayer` properties given in the chapter is no longer current in a few places. All the properties listed as IUOs are now optionals. The type of the `actions` dictionary is now `[String : CAAction]?`.

The static property on `CGPoint` which yields the zero point has been renamed from `zeroPoint` to `zero`. This results in a number of changes throughout the chapter. Also, the corresponding property on `CGSize` has been changed from `zeroSize` to `zero`. Similarly, `CGRect`'s static property has changed to `zero` from `zeroRect`.

p. 474: Among the other changes to `CALayer` in OS X 10.11 thanks to auditing of IUOs, the `superlayer` property is now `CALayer?` rather than `CALayer!`. To adapt to this improved API, force-unwrap the `superlayer` when it is accessed in the `didSet` of the `ViewController`'s `text` property:

    textLayer.superlayer!.bounds = CGRect(x: 0, y: 0, width: size.width + 16, height: size.height + 20)

p. 473: The `NSURL` initializer `NSURL(fileURLWithPath:)` is no longer failable. As a result, it is no longer necessary (or allowed) to force-unwrap the result of the initializer. The second-to-last line of `ViewController`'s method `viewDidLoad()` is therefore:

        let url = NSURL(fileURLWithPath: "/Library/Desktop Pictures")

p. 475: In Swift 2, it is no longer permissible to use `nil` to name an empty option set. As you saw in the section on Chapter 25 (Auto Layout), the approach is now to use the empty array literal syntax (`[]`). This requires that the `NSDirectoryEnumerationOptions` argument passed to `enumeratorAtURL(_:includingPropertiesForKeys:options:errorHandler:)` be changed in the implementation of `ViewController.addImagesFromFolderURL(_:)` as follows:

        let directoryEnumerator = fileManager.enumeratorAtURL(folderURL,
                                  includingPropertiesForKeys: nil,
                                                     options: [],
                                                errorHandler: nil)!

The error handling changes in Swift 2 require that `NSURL`'s method `getResourceValue(_:forKey:)` be changed. The old usage in `ViewController`'s method `addImagesFromFolderURL(_:)`: 

            var isDirectoryValue: AnyObject?
            var error: NSError?
            url.getResourceValue(&isDirectoryValue,
                         forKey: NSURLIsDirectoryKey,
                          error: &error)

is now as follows:

            var isDirectoryValue: AnyObject?
            do {
                try url.getResourceValue(&isDirectoryValue,
                                 forKey: NSURLIsDirectoryKey)
            } catch {
                print("error checking whether URL is directory: \(error)")
                continue
            }

With these changes, `addImagesFromFolderURL(_:)` is now:

    func addImagesFromFolderURL(folderURL: NSURL) {
        let t0 = NSDate.timeIntervalSinceReferenceDate()
        
        let fileManager = NSFileManager()
        let directoryEnumerator = fileManager.enumeratorAtURL(folderURL,
                                                              includingPropertiesForKeys: nil,
                                                              options: [],
                                                              errorHandler: nil)!
        
        var allowedFiles = 10
        
        while let url = directoryEnumerator.nextObject() as? NSURL {
            // Skip directories:
            
            var isDirectoryValue: AnyObject?
            do {
                try url.getResourceValue(&isDirectoryValue,
                                 forKey: NSURLIsDirectoryKey)
            } catch {
                print("error checking whether URL is directory: \(error)")
                continue
            }
            
            if let isDirectory = isDirectoryValue as? Bool
               where isDirectory == false {
                    if let image = NSImage(contentsOfURL: url) {
                        allowedFiles--
                        if allowedFiles < 0 {
                            break
                        }
                        
                        let thumbImage = thumbImageFromImage(image)
                        
                        presentImage(thumbImage)
                        let t1 = NSDate.timeIntervalSinceReferenceDate()
                        let interval = t1 - t0
                        text = String(format: "%0.1fs", interval)
                    }
            }
        }
    }

You can make this more stylish by using Swift 2's new keyword `guard`. This keyword allows you to avoid nested `if`s. Here is how `addImagesFromFolderURL(_:)` would look with a healthy usage of `guard`:

    func addImagesFromFolderURL(folderURL: NSURL) {
        let t0 = NSDate.timeIntervalSinceReferenceDate()
        
        let fileManager = NSFileManager()
        let directoryEnumerator = fileManager.enumeratorAtURL(folderURL,
                                  includingPropertiesForKeys: nil,
                                                     options: [],
                                                errorHandler: nil)!
        
        var allowedFiles = 10
        
        while let url = directoryEnumerator.nextObject() as? NSURL {
            // Skip directories:
            
            var isDirectoryValue: AnyObject?
            do {
                try url.getResourceValue(&isDirectoryValue,
                                 forKey: NSURLIsDirectoryKey)
            } catch {
                print("error checking whether URL is directory: \(error)")
                continue
            }
            
            guard let isDirectory = isDirectoryValue as? Bool where
                  isDirectory == false else {
                    continue
            }
            
            guard let image = NSImage(contentsOfURL: url) else {
                continue
            }
            
            allowedFiles--
            guard allowedFiles >= 0 else {
                break
            }
            
            let thumbImage = thumbImageFromImage(image)
            
            presentImage(thumbImage)
            let t1 = NSDate.timeIntervalSinceReferenceDate()
            let interval = t1 - t0
            text = String(format: "%0.1fs", interval)
        }
    }

## Chapter 34. Concurrency

p. 485: With the adaptations for Swift 2 from the previous chapter, the method `addImagesFromFolderURL(_:)` on `ViewController` looks as follows after the modifications described in this chapter:

    func addImagesFromFolderURL(folderURL: NSURL) {
        processingQueue.addOperationWithBlock {
            let t0 = NSDate.timeIntervalSinceReferenceDate()
            
            let fileManager = NSFileManager()
            let directoryEnumerator = fileManager.enumeratorAtURL(folderURL,
                includingPropertiesForKeys: nil,
                options: [],
                errorHandler: nil)!
            
            while let url = directoryEnumerator.nextObject() as? NSURL {
                // Skip directories:
                
                var isDirectoryValue: AnyObject?
                do {
                    try url.getResourceValue(&isDirectoryValue,
                        forKey: NSURLIsDirectoryKey)
                } catch {
                    print("error checking whether URL is directory: \(error)")
                    continue
                }
                
                if let isDirectory = isDirectoryValue as? Bool
                   where isDirectory == false {
                    self.processingQueue.addOperationWithBlock {
                        if let image = NSImage(contentsOfURL: url) {
                            let thumbImage = self.thumbImageFromImage(image)
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.presentImage(thumbImage)
                                let t1 = NSDate.timeIntervalSinceReferenceDate()
                                let interval = t1 - t0
                                self.text = String(format: "%0.1fs", interval)
                            }
                        }
                    }
                }
            }
        }
    }

As you can see, the indentation of this method is getting out of hand. In Swift 2, `guard` comes to the rescue:

    func addImagesFromFolderURL(folderURL: NSURL) {
        processingQueue.addOperationWithBlock {
            let t0 = NSDate.timeIntervalSinceReferenceDate()
            
            let fileManager = NSFileManager()
            let directoryEnumerator = fileManager.enumeratorAtURL(folderURL,
                                      includingPropertiesForKeys: nil,
                                                         options: [],
                                                    errorHandler: nil)!
            
            while let url = directoryEnumerator.nextObject() as? NSURL {
                // Skip directories:
                
                var isDirectoryValue: AnyObject?
                do {
                    try url.getResourceValue(&isDirectoryValue,
                        forKey: NSURLIsDirectoryKey)
                } catch {
                    print("error checking whether URL is directory: \(error)")
                    continue
                }
                
                self.processingQueue.addOperationWithBlock {
                    guard let isDirectory = isDirectoryValue as? Bool where
                        isDirectory == false else {
                            return
                    }
                
                    guard let image = NSImage(contentsOfURL: url) else {
                        return
                    }
                    
                    let thumbImage = self.thumbImageFromImage(image)
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.presentImage(thumbImage)
                        let t1 = NSDate.timeIntervalSinceReferenceDate()
                        let interval = t1 - t0
                        self.text = String(format: "%0.1fs", interval)
                    }
                }
            }
        }
    }

p. 486: In the section "Thread synchronization", there is some code which illustrates using a lock to protect access to an array. With Swift 2's new keyword `defer`, this code is now as follows:

    let lock = NSRecursiveLock()
    func addImage(image: NSImage) {
        lock.lock()
        defer {
            lock.unlock()
        }
        images.append(image)
    }

This guarantees that `unlock()` will be called on the `lock` no matter how `addImage(_:)` returns. This would be especially useful if `addImage(_:)` was a throwing method. In that case, even if the method exited by throwing an error, the lock would still have `unlock()` called on it.

## Chapter 35. NSTask

p. 492: Due to the error handling changes in Swift 2, the signature of `readFromURL(_:ofType:)` has changed to throw an error. With this change, the implementation of this method in `Document` of the ZIPspector app becomes: 

    override func readFromURL(url: NSURL, ofType typeName: String) throws {
        // Which file are we getting the zipinfo for?
        let filename = url.path!
        
        // Prepare a task object
        let task = NSTask()
        task.launchPath = "/usr/bin/zipinfo"
        task.arguments = ["-1", filename]
        
        // Create the pipe to read from
        let outPipe = NSPipe()
        task.standardOutput = outPipe
        
        // Start the process
        task.launch()
        
        // Read the output
        let fileHandle = outPipe.fileHandleForReading
        let data = fileHandle.readDataToEndOfFile()
        
        // Make sure the task terminates normally
        task.waitUntilExit()
        let status = task.terminationStatus
        
        // Check status
        guard status == 0 else {
            let errorDomain = "com.bignerdranch.ProcessReturnCodeErrorDomain"
            let errorInfo
                = [ NSLocalizedFailureReasonErrorKey : "zipinfo returned \(status)"]
            let error = NSError(domain: errorDomain,
                                  code: 0,
                              userInfo: errorInfo)
            throw error
        }
        
        // Convert to a string
        let string = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        // Break the string into lines
        filenames = string.componentsSeparatedByString("\n")
        print("filenames = \(filenames)")
        
        // In case of revert
        tableView?.reloadData()
    }

Notice the use of the new Swift 2 keyword `guard`. This ensures that execution of the method will only continue if `status` does indeed equal `0`.
