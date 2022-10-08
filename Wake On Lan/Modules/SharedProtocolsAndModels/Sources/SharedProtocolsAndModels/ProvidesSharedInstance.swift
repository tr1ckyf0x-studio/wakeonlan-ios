import Foundation

public protocol ProvidesSharedInstance: AnyObject {
    static var shared: Self { get }
    static var weakSharedInstance: Self? { get set }

    init()
}

public protocol ProvidesWeakSharedInstanceTrait: ProvidesSharedInstance {
}

extension ProvidesSharedInstance where Self: ProvidesWeakSharedInstanceTrait {
    public static var shared: Self {
        if let weakSharedInstance {
            return weakSharedInstance
        }
        let instance = Self()
        weakSharedInstance = instance
        return instance
    }
}
