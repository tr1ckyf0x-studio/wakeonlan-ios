import Foundation

public protocol ProvidesSharedInstance: AnyObject {
    static var shared: Self { get }
}

public protocol ProvidesWeakSharedInstanceTrait: ProvidesSharedInstance {
    static var weakSharedInstance: Self? { get set }

    init()
}

extension ProvidesWeakSharedInstanceTrait {
    public static var shared: Self {
        if let weakSharedInstance {
            return weakSharedInstance
        }
        let instance = Self()
        weakSharedInstance = instance
        return instance
    }
}
