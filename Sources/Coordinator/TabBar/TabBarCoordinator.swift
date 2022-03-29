import UIKit

open class TabBarCoordinator: Coordinator {
    
    // MARK: - Public properties

    public private(set) var tabBarController: UITabBarController?
    public private(set) var coordinators: [TabBarItemCoordinator]
    public let initiallySelectedIndex: Int
    
    // MARK: - Private properties
    
    private var selectedViewControllerObserver: NSKeyValueObservation?
    
    // MARK: - Initialization
    
    public init(tabBarController: UITabBarController = UITabBarController(),
                coordinators: [TabBarItemCoordinator], initiallySelectedIndex: Int = 0) {
        
        self.tabBarController = tabBarController
        self.coordinators = coordinators
        self.initiallySelectedIndex = initiallySelectedIndex
        
        super.init()
    }
    
    deinit {
        selectedViewControllerObserver?.invalidate()
        selectedViewControllerObserver = nil
    }
    
    // MARK: - Start
    
    open override func start(animated: Bool = true, completion: (() -> Void)? = nil) {
        tabBarController?.setViewControllers(
            coordinators.compactMap { $0.navigationController }, animated: animated)
        tabBarController?.selectedIndex = initiallySelectedIndex
        
        selectedViewControllerObserver = tabBarController?.observe(\
            .selectedViewController, options: [.initial, .new]) {
                [weak self] tabBarController, change in
                guard let selectedViewController = change.newValue as? UINavigationController,
                    let index = self?.coordinators.firstIndex(
                        where: { $0.navigationController === selectedViewController }),
                    let coordinator = self?.coordinators[index],
                    coordinator.isStarted == false else {
                    return
            }
            self?.coordinators[index].start()
        }
    }
    
    // MARK: - Finish
    
    public override func finish() {
        coordinators.forEach { $0.finish() }
        super.finish()
    }
    
    // MARK: - Public methods

    public func coordinator<T: Coordinator>(for index: Int) -> T? {
        guard coordinators.indices.contains(index) else {
            return nil
        }

        return coordinators[index] as? T
    }
    
    public func selectTabBarItem(for index: Int) {
        guard coordinators.indices.contains(index) else {
            assertionFailure("Invalid tab index")
            return
        }
        tabBarController?.selectedViewController = coordinators[index].navigationController
    }
}
