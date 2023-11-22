//
//  CollectionViewController.swift
//  PBPopupSample
//
//  Created by Oleksandr Balabon on 22.12.2022.
//


import UIKit
import PBPopupController

class CollectionViewController: UIViewController {
    
    var popupContentVC: PopupContentViewController!
    weak var containerVC: UIViewController!
    var popupPlayButtonItem: UIBarButtonItem!
    var popupCloseButtonItem: UIBarButtonItem!
    
    let titles = ["Respect", "Fight the Power", "A Change Is Gonna Come", "Like a Rolling Stone", "Smells Like Teen Spirit", "What’s Going On", "Strawberry Fields Forever", "Get Ur Freak On", "Dreams", "Hey Ya!", "God Only Knows", "Superstition", "Gimme Shelter", "Waterloo Sunset", "I Want to Hold Your Hand", "Crazy in Love", "Bohemian Rhapsody", "Purple Rain"]
    
    var collectionView: UICollectionView?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupContainerVC()
        
        let moveButton = UIBarButtonItem(title: "Move", style: .plain, target: self, action: #selector(openSecondViewController))
        navigationItem.leftBarButtonItem = moveButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        
        if let containerVC = self.containerVC, let popupContentView = containerVC.popupContentView {
            popupContentView.popupContentSize = CGSize(width: -1, height: self.containerVC.view.bounds.height * 0.85)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.popupContentVC = PopupContentViewController()
        self.commonSetup()
        self.createBarButtonItems()
        
        if self.containerVC.popupController.popupPresentationState == .closed {
            self.presentPopupBar()
        }
    }
    
    // Transition to Setting
    @objc func openSecondViewController() {
        let vc = SecondViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self
        present(navigationController, animated: true)
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.setupTextLabel(labelText: titles[indexPath.row])
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3.4, height: view.frame.size.width / 3.4)
    }
}

extension CollectionViewController {
    
    func collectionView( _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        displayItemOnTapByIndexPath(indexPath: indexPath)
        return false
    }
}

extension CollectionViewController {
    
    // Setup Collections
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        view.addSubview(collectionView!)
    }
    
    
    // Press Cell
    private func displayItemOnTapByIndexPath(indexPath: IndexPath){
        self.updatePopupBar(forRowAt: indexPath.row)
        self.presentPopupBar()
    }
}

// MARK: - PBPopup
extension CollectionViewController: PBPopupControllerDataSource, PBPopupControllerDelegate, PBPopupBarDataSource, PBPopupBarPreviewingDelegate {
    
    func setupContainerVC() {
        if let navigationController = self.navigationController as? NavigationController {
            self.containerVC = navigationController
            if let containerController = navigationController.parent {
                self.containerVC = containerController
            }
        } else {
            self.containerVC = self
        }
    }
    
    func commonSetup(){
        if (self.containerVC?.popupBar) != nil {
            self.containerVC.popupController.delegate = self
            if let popupContentView = self.containerVC.popupContentView {
                popupContentView.popupPresentationStyle = .fullScreen
                popupContentView.popupIgnoreDropShadowView = true // visual effect of Modal Page Sheet - false
                popupContentView.popupPresentationDuration = 0.45
                popupContentView.popupCanDismissOnPassthroughViews = true
            }
        }
    }
    
    func createBarButtonItems() {
        self.popupPlayButtonItem = UIBarButtonItem()
        self.popupCloseButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil)
        self.configureBarButtonItems()
    }
    
    func configureBarButtonItems(){
        if let popupBar = self.containerVC.popupBar {
            popupBar.leftBarButtonItems = nil
            popupBar.rightBarButtonItems = [self.popupPlayButtonItem, self.popupCloseButtonItem]
            popupBar.progressViewStyle = .top
            let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
            
            if let pauseImage = UIImage(systemName: "play.fill", withConfiguration: configuration) {
                let playPauseAction: Selector = #selector(self.playPauseAction(_:))
                let popupPlayButtonItem = UIBarButtonItem.popupButtonItem(self, action: playPauseAction, image: pauseImage)
                self.popupPlayButtonItem = popupPlayButtonItem
            }
            
            if let closeImage = UIImage(systemName: "xmark", withConfiguration: configuration){
                let closeAction = #selector(self.closeAction)
                let closeButtonItem = UIBarButtonItem.popupButtonItem(self, action: closeAction, image: closeImage)
                popupCloseButtonItem = closeButtonItem
            }
        }
    }
    
    @objc func presentPopupBar(){
        self.commonSetup()
        self.setupPopupBar()
        self.configureBarButtonItems()
        self.containerVC.presentPopupBar(withPopupContentViewController: self.popupContentVC, animated: true, completion: {
            print("Popup Bar Presented")
        })
    }
    
    private func updatePopupBar(forRowAt index: Int) {
        self.containerVC.popupBar.image = UIImage(systemName: "headphones")
        self.containerVC.popupBar.title = titles[index]
        self.containerVC.popupBar.subtitle = "Track subtitle"
    }
    
    func setupPopupBar(){
        if let popupBar = self.containerVC.popupBar {
            popupBar.dataSource = self
            popupBar.previewingDelegate = self
            popupBar.inheritsVisualStyleFromBottomBar = true
            popupBar.shadowImageView.shadowOpacity = 0
            popupBar.borderViewStyle = .none
        }
    }
    
    @objc func playPauseAction(_ sender: Any?) {
        print("playPauseAction")
    }
    
    @objc func closeAction(_ sender: Any) {
        print("closeAction")
        self.containerVC.dismissPopupBar(animated: true)
    }
}

extension CollectionViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }
}
