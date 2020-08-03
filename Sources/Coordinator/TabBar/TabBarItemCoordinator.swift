import UIKit

public class TabBarItemCoordinator: Coordinator {
    
    // MARK: - Public properties
    
    public var isStarted: Bool = false
    
    // MARK: - Private properties
    
    private let tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    
    init(tabBarItem: UITabBarItem, navigationController: UINavigationController) {
        self.tabBarItem = tabBarItem
        navigationController.tabBarItem = tabBarItem
        
        super.init(navigationController: navigationController)
    }
    
    // MARK: - Start
    
    public override func start(animated: Bool = true, completion: (() -> ())? = nil) {
        isStarted = true
    }
}
