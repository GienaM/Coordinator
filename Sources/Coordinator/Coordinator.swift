import UIKit

open class Coordinator: NSObject, CoordinatorInterface {
    
    // MARK: - Public properties
    
    public private(set) var navigationController: UINavigationController?
    public private(set) weak var modalNavigationController: UINavigationController?
    
    public private(set) var childCoordinator: Coordinator? {
        willSet {
            childCoordinator?.finish()
        }
    }
    
    public private(set) var modalChildCoordinator: Coordinator? {
        willSet {
            modalChildCoordinator?.finish()
        }
    }
    
    // MARK: - Initialization
    
    public init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        
        super.init()
        print("Coordinator init: \(self)")
    }
    
    deinit {
        print("Coordinator deinit: \(self)")
    }
    
    // MARK: - Routing
    
    open func start(animated: Bool = true, completion: (() -> Void)? = nil) {
        print("Coordinator: \(self) start")
    }
    
    open func finish() {
        modalNavigationController?.dismiss(animated: false, completion: nil)
        modalNavigationController = nil
        childCoordinator?.finish()
        modalChildCoordinator?.finish()
        modalChildCoordinator = nil
        childCoordinator = nil
        navigationController = nil
    }
}
