protocol Parent: class {
    associatedtype Child
    var children: [Child] { get }
}

typealias ParentCoordinator = Coordinator & Parent
