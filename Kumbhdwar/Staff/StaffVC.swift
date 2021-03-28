//
//  StaffVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/25/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//


import UIKit
import MaterialPageControl
import CHIPageControl
import CoreLocation
import MapKit
import DropDown


enum StaffList: CaseIterable {
    case Attendance,Task,Leave
    
    var text: String {
        switch self {
        case .Attendance: return "Attendance"
        case .Task: return "Task"
        case .Leave: return "Leave"
        }
    }
    var image: UIImage {
        switch self {
        case .Attendance: return #imageLiteral(resourceName: "local")
        case .Task: return #imageLiteral(resourceName: "complaints_icon")
        case .Leave: return #imageLiteral(resourceName: "complaint_icon")

        }
    }
}


class StaffVC: UIViewController {
    @IBOutlet weak var imagesBgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var marqueeLAbel: MarqueeLabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var logoutMenu: UIButton!

    @IBOutlet weak var aleppoPAgeControl: CHIPageControlAleppo!
    @IBOutlet var viewCollections: [UIView]!
    
    private let colors: [UIColor] = [.green, .blue, .black]
    var timer = Timer()
    var counter = 0
    let kumbhdwarImages = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"), #imageLiteral(resourceName: "three"), #imageLiteral(resourceName: "four"), #imageLiteral(resourceName: "five"), #imageLiteral(resourceName: "six"), #imageLiteral(resourceName: "seven")]
    var x = 1
    let loadUrls = [Constants.introductionUrl, Constants.attractionsUrl, Constants.howToReachUrl, Constants.accommodationUrl]
    let amenityIds = ["2,4","6,8" ,"5,10,14,15,11", "6,11"]
    let dropDown = DropDown()
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupUI()
        setupDropDown()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 13, *)
        {
            if let frame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame {
                let statusBar = UIView(frame: frame)
                statusBar.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0, alpha: 1)
                UIApplication.shared.keyWindow?.addSubview(statusBar)
            }
        }
        
        collectionView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    }
    func setupDropDown() {
        dropDown.anchorView = self.logoutMenu // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Logout"]
        dropDown.width = 120
        dropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        DropDown.appearance().textColor = #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0, alpha: 1)
        DropDown.appearance().backgroundColor = UIColor.white

    }
    
    
    @objc func didChangePage(sender: MaterialPageControl) {
        var offset = imagesCollectionView.contentOffset
        offset.x = CGFloat(sender.currentPage) * imagesCollectionView.bounds.size.width
        imagesCollectionView.setContentOffset(offset, animated: true)
    }
    private func setupCollectionView() {
        imagesBgView.addSubview(imagesCollectionView)
        imagesCollectionView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 32).isActive = true
        imagesCollectionView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        imagesCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imagesCollectionView.topAnchor.constraint(equalTo: self.imagesBgView.topAnchor, constant: 10).isActive = true
   
    }
    
    private func setupMarqueLabel() {
        marqueeLAbel.type = .continuous
        marqueeLAbel.scrollDuration = 45.0
        marqueeLAbel.animationCurve = .easeInOut
        marqueeLAbel.fadeLength = 10.0
        marqueeLAbel.leadingBuffer = 20.0
        marqueeLAbel.trailingBuffer = 20.0
    }
    private func setupUI() {
        self.title = "KUMBHDWAR"
        DispatchQueue.main.async {
              self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        locationManager.requestWhenInUseAuthorization()
        logoImageView.round(enable: true, withRadius: logoImageView.frame.height/2)
            setupMarqueLabel()
        aleppoPAgeControl.delegate = self
        for view in viewCollections {
            let cornerRadius = view.bounds.height/2
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
            
        }
    }
    @IBAction func sosButtonTapped(_ sender: Any) {
        
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.imagesCollectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    

    @objc func changeImage() {

         if counter < kumbhdwarImages.count {
              let index = IndexPath.init(item: counter, section: 0)
              self.imagesCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            aleppoPAgeControl.progress = Double(counter)
              counter += 1
         } else {
              counter = 0
              let index = IndexPath.init(item: counter, section: 0)
              self.imagesCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            aleppoPAgeControl.progress = Double(counter)
               counter = 1
           }
      }
    @IBAction func logOutMenuTapped(_ sender: UIButton) {
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = { (index: Int, item: String) in
            
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to sign out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        print("default")
                    UserManager.shared.userLogout()
                    DispatchQueue.main.async {
                        let loginNavVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNav")
                        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDel.window?.rootViewController = loginNavVC
                    }
                  case .cancel:
                        print("cancel")

                  case .destructive:
                        print("destructive")


                  @unknown default:
                    fatalError()
                  }}))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
           
        }
    }
    
}
extension StaffVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CHIBasePageControlDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == imagesCollectionView ? kumbhdwarImages.count : StaffList.allCases.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == imagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bCell", for: indexPath)
            let imageView = UIImageView(frame: CGRect(x: cell.contentView.frame.origin.x, y: cell.contentView.frame.origin.y, width: cell.contentView.frame.width, height: cell.contentView.frame.height))
            imageView.image = kumbhdwarImages[indexPath.row]
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            cell.contentView.addSubview(imageView)
            imageView.round()
            cell.backgroundColor = .clear
            return cell
            
        }
        if indexPath.item == StaffList.allCases.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.StoryboardIdentifiers.socialIntegraionCell, for: indexPath) as? SocialIntegraionCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.StoryboardIdentifiers.staffCollectionCell, for: indexPath) as? StaffCollectionCell else { return UICollectionViewCell() }
            let item = StaffList.allCases[indexPath.item]
            cell.textLabel.text = item.text
            cell.imageView.image = item.image
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imagesCollectionView {
            let width = self.imagesCollectionView.frame.width
            let height = self.imagesCollectionView.frame.size.height
            return CGSize(width: width, height: height)
        } else {
            switch indexPath.item {
            case StaffList.allCases.count :
                let width = self.collectionView.frame.size.width - 20 - 16
                let height:CGFloat = 60.0
                return CGSize(width: width, height: height)
            default:
                let width = (self.collectionView.frame.size.width - 20 - 16 ) / 2
                let height:CGFloat = 90.0
                return CGSize(width: width, height: height)
            }
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            guard let attendanceVC = UIStoryboard(name: Constants.StroyboardFiles.staff, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.attendanceVC) as? AttendanceVC else { return }
            self.navigationController?.pushViewController(attendanceVC, animated: true)
            break
            
        case 1:
            guard let taskVC = UIStoryboard(name: Constants.StroyboardFiles.staff, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.taskVC) as? TaskVC else { return }
            self.navigationController?.pushViewController(taskVC, animated: true)
            break
        case 2:
            guard let leaveVC = UIStoryboard(name: Constants.StroyboardFiles.staff, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.leaveVC) as? LeaveVC else { return }
            self.navigationController?.pushViewController(leaveVC, animated: true)
            break
        
        default: return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        let percent = Double(offset / total)
        
        let progress = percent * Double(self.kumbhdwarImages.count - 1)
        self.aleppoPAgeControl.progress = progress
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        imagesCollectionView.scrollToItem(at: context.nextFocusedItem as! IndexPath, at: .centeredHorizontally, animated: true)

    }
    func didTouch(pager: CHIBasePageControl, index: Int) {
        print(pager, index)
        
    }
    func successLabel(view: UIView, message: String, completion: ((Bool) -> Void)?) {
        
        let backgroundView = UIView(frame: CGRect(x: 50, y: view.frame.size.height - 150, width: view.frame.size.width - 80, height: 40))
        
        backgroundView.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        backgroundView.round(enable: true, withRadius: nil)
        
        let label = UILabel(frame: CGRect(x: backgroundView.frame.origin.x + 5, y: backgroundView.frame.origin.y, width: backgroundView.frame.width - 10, height: 40))
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = message
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        view.addSubview(backgroundView)
        view.addSubview(label)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            backgroundView.removeFromSuperview()
            label.removeFromSuperview()
            completion?(true)
        }
        
    }
        
}
