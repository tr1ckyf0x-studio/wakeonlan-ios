import Foundation

public protocol ProvidesSharedInstance: AnyObject {
    static var shared: Self { get }
}

public protocol ProvidesWeakSharedInstanceTrait: ProvidesSharedInstance {
    static var weakSharedInstance: Self? { get set }

    static func provideDefaultInstance() -> Self
}

extension ProvidesSharedInstance where Self: ProvidesWeakSharedInstanceTrait {
    public static var shared: Self {
        if let weakSharedInstance {
            return weakSharedInstance
        }
        let instance = provideDefaultInstance()
        weakSharedInstance = instance
        return instance
    }
}
