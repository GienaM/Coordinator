import UIKit

open class TabBarCoordinator: Coordinator {
    
    // MARK: - Public properties

    public private(set) weak var tabBarController: UITabBarController?
    public private(set) var coordinators: [Coordinator]
    public let initiallySelectedIndex: Int
    
    // MARK: - Private properties
    
    private var selectedViewControllerObserver: NSKeyValueObservation?
    
    // MARK: - Initialization
    
    public init(tabBarController: UITabBarController = UITabBarController(),
                coordinators: [Coordinator], initiallySelectedIndex: Int = 0) {
        
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
    
    open override func start(animated: Bool = true, completion: (() -> ())? = nil) {
        tabBarController?.setViewControllers(
            coordinators.compactMap { $0.navigationController }, animated: animated)
        tabBarController?.selectedIndex = initiallySelectedIndex
        
        selectedViewControllerObserver = tabBarController?.observe(\
            .selectedViewController, options: [.initial, .new]) {
                [weak self] tabBarController, change in
                guard let selectedViewController = change.newValue as? UINavigationController,
                    selectedViewController.isViewLoaded == false,
                    let index = self?.coordinators.firstIndex(
                    where: { $0.navigationController === selectedViewController }) else {
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
    
    public func selectTabBarItem(for index: Int) {
        guard coordinators.indices.contains(index) else {
            assertionFailure("Invalid tab index")
            return
        }
        tabBarController?.selectedViewController = coordinators[index].navigationController
    }
}
