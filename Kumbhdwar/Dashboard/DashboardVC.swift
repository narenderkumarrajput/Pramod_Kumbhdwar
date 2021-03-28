//
//  DashboardVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/13/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import MaterialPageControl
import CHIPageControl
import CoreLocation
import MapKit
import DropDown


enum KumbhdwarList: CaseIterable {
    case introduction,holyCityAttractions,Akhada, ghats, liveAarti, FriendsFamily, journeyPlanner, accommodation, parking, localFacilities, publicTransport, findMyCar, nearMe, SOSList, exitPlan, Feedback, OfficialNo
    
    var text: String {
        switch self {
        case .introduction: return "Introduction"
        case .holyCityAttractions: return "Holy City Attractions"
        case .Akhada: return "Akhada"
        case .ghats: return "Ghats"
        case .liveAarti: return "Live Aarti"
        case .FriendsFamily: return "Friends&Family"
        case .journeyPlanner: return "Journey Planner"
        case .accommodation: return "Accomodation"
        case .parking: return "Parking"
        case .localFacilities: return "Local Facilities"
        case .publicTransport: return "Public Transport"
        case .findMyCar: return "Find My Car"
        case .nearMe: return "Near Me"
        case .SOSList: return "SOS List"
        case .exitPlan: return "Exit Plan"
        case .Feedback: return "Feedback"
        case .OfficialNo: return "Official No."
            
            
        }
    }
    var image: UIImage {
        switch self {
        case .introduction: return #imageLiteral(resourceName: "introduction")
        case .holyCityAttractions: return #imageLiteral(resourceName: "attractions")
        case .Akhada: return #imageLiteral(resourceName: "person")
        case .ghats: return #imageLiteral(resourceName: "ghat")
        case .liveAarti: return #imageLiteral(resourceName: "aarti")
        case .FriendsFamily: return #imageLiteral(resourceName: "tracker")
        case .journeyPlanner: return #imageLiteral(resourceName: "journey_planner")
        case .accommodation: return #imageLiteral(resourceName: "booking")
        case .parking: return #imageLiteral(resourceName: "parking")
        case .localFacilities: return #imageLiteral(resourceName: "local")
        case .publicTransport: return #imageLiteral(resourceName: "transport.jpg")
        case .findMyCar: return #imageLiteral(resourceName: "find_car")
        case .nearMe: return #imageLiteral(resourceName: "near")
        case .SOSList: return #imageLiteral(resourceName: "sos")
        case .exitPlan: return #imageLiteral(resourceName: "exit")
        case .Feedback: return #imageLiteral(resourceName: "complaints_icon")
        case .OfficialNo: return #imageLiteral(resourceName: "phone")
        }
    }
}


class DashboardVC: UIViewController {

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
        marqueeLAbel.scrollDuration = 90.0
        marqueeLAbel.animationCurve = .linear
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
    @IBAction func facebookTapped(_ sender: UIButton) {
        if let url = URL(string: "https://www.facebook.com/2021mahakumbh/") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func twitterTapped(_ sender: UIButton) {
        if let url = URL(string: "https://twitter.com/2021mahakumbh") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func instagramTapped(_ sender: UIButton) {
        if let url = URL(string: "https://www.instagram.com/haridwarkumbh2021/") {
            UIApplication.shared.open(url)
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
extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CHIBasePageControlDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == imagesCollectionView ? kumbhdwarImages.count : KumbhdwarList.allCases.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == imagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aCell", for: indexPath)
            let imageView = UIImageView(frame: CGRect(x: cell.contentView.frame.origin.x, y: cell.contentView.frame.origin.y, width: cell.contentView.frame.width, height: cell.contentView.frame.height))
            imageView.image = kumbhdwarImages[indexPath.row]
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            cell.contentView.addSubview(imageView)
            imageView.round()
            cell.backgroundColor = .clear
            return cell
            
        }
        if indexPath.item == KumbhdwarList.allCases.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.StoryboardIdentifiers.socialIntegraionCell, for: indexPath) as? SocialIntegraionCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.StoryboardIdentifiers.dashboardCell, for: indexPath) as? DashboardCollectionCell else { return UICollectionViewCell() }
            let item = KumbhdwarList.allCases[indexPath.item]
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
            case KumbhdwarList.allCases.count :
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
        case 0,1:
            guard let introVC = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.introductionVC) as? IntroductionVC else { return }
            introVC.index = indexPath.row
            introVC.text = KumbhdwarList.allCases[indexPath.item].text
            self.navigationController?.pushViewController(introVC, animated: true)
            break
            
        case 2:
            guard let introVC = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.akhadaVC) as? AkhadaVC else { return }
            self.navigationController?.pushViewController(introVC, animated: true)
        case 3,8,9,10:
            guard let parkingVC = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.parkingVC) as? ParkingVC else { return }
            parkingVC.title = KumbhdwarList.allCases[indexPath.item].text
                parkingVC.amenityTypeId =  indexPath.item == 3 ? amenityIds[0] : amenityIds[indexPath.item - 7]
            self.navigationController?.pushViewController(parkingVC, animated: true)
            break
        case 4:
            successLabel(view: self.view, message: "Work in progress", completion: nil)
        case 5:
            guard let trackerList = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.trackerList) as? TrackerList else { return }
            self.navigationController?.pushViewController(trackerList, animated: true)
        case 6:
            guard let journeyPlannerVC = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.journeyPlannerVC) as? JourneyPlannerVC else { return }
            self.navigationController?.pushViewController(journeyPlannerVC, animated: true)

        case 7:
            guard let accommodationVC = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.accommodationVC) as? AccommodationVC else { return }
            self.navigationController?.pushViewController(accommodationVC, animated: true)
        case 15:
            guard let feedbackStatus = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.feedbackStatusVC) as? FeedbackStatusVC else { return }
            self.navigationController?.pushViewController(feedbackStatus, animated: true)
            break
            
        case 11:
            showCarPark()
        case 12:
            nearMe()
        case 13:
            showSOS()
        case 16:
            guard let officailNo = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.officialNo) as? OfficialNoVC else { return }
            self.navigationController?.pushViewController(officailNo, animated: true)
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

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        minimumLineSpacing = 14.0
        minimumInteritemSpacing = 14.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin + 10
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
            
            
        }

        return attributes
    }
}

extension DashboardVC {
    private func dummmyData() -> [UserLocation] {
        var userLocation: [UserLocation] = []
        userLocation.append(UserLocation(latLong: CLLocationCoordinate2D(latitude: 25.4358, longitude: 81.8463), name: "ABCDEFG 1"))
        userLocation.append(UserLocation(latLong: CLLocationCoordinate2D(latitude: 25.5358, longitude: 81.6463), name: "ABCDEFG 2"))
        userLocation.append(UserLocation(latLong: CLLocationCoordinate2D(latitude: 25.6358, longitude: 81.7463), name: "ABCDEFG 3"))
        userLocation.append(UserLocation(latLong: CLLocationCoordinate2D(latitude: 25.6358, longitude: 81.9463), name: "ABCDEFG 4"))
        return userLocation
    }
    
    private func showAddTracker() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var mapTrackerVC = MapTrackerViewController()
        if #available(iOS 13.0, *) {
            mapTrackerVC = (sb.instantiateViewController(identifier: "MapTrackerViewController") as? MapTrackerViewController)!
        } else {
            mapTrackerVC = sb.instantiateViewController(withIdentifier: "MapTrackerViewController") as! MapTrackerViewController
        }
        mapTrackerVC.usersLocationsWithName = self.dummmyData()
        self.navigationController?.pushViewController(mapTrackerVC, animated: true)
    }
    
    private func showSOS() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var sosVC = SOSViewController()
        if #available(iOS 13.0, *) {
            sosVC = (sb.instantiateViewController(identifier: "SOSViewController") as? SOSViewController)!
        } else {
            sosVC = sb.instantiateViewController(withIdentifier: "SOSViewController") as! SOSViewController
        }
        self.navigationController?.pushViewController(sosVC, animated: true)
    }
    
    private func showCarPark() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var sosVC = CarParkMapViewController()
        if #available(iOS 13.0, *) {
            sosVC = (sb.instantiateViewController(identifier: "CarParkMapViewController") as? CarParkMapViewController)!
        } else {
            sosVC = sb.instantiateViewController(withIdentifier: "CarParkMapViewController") as! CarParkMapViewController
        }
        self.navigationController?.pushViewController(sosVC, animated: true)
    }
    private func nearMe() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var nearMeVC = NearMeViewController()
        if #available(iOS 13.0, *) {
            nearMeVC = (sb.instantiateViewController(identifier: "NearMeViewController") as? NearMeViewController)!
        } else {
            nearMeVC = sb.instantiateViewController(withIdentifier: "NearMeViewController") as! NearMeViewController
        }
        self.navigationController?.pushViewController(nearMeVC, animated: true)
    }
    
    private func showlocation() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var nearMeVC = LocationsViewController()
        if #available(iOS 13.0, *) {
            nearMeVC = (sb.instantiateViewController(identifier: "LocationsViewController") as? LocationsViewController)!
        } else {
            nearMeVC = sb.instantiateViewController(withIdentifier: "LocationsViewController") as! LocationsViewController
        }
        self.navigationController?.pushViewController(nearMeVC, animated: true)
    }
    
    private func showAddJourneyRegVC() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var nearMeVC = AddJourneyRegViewController()
        if #available(iOS 13.0, *) {
            nearMeVC = (sb.instantiateViewController(identifier: "AddJourneyRegViewController") as? AddJourneyRegViewController)!
        } else {
            nearMeVC = sb.instantiateViewController(withIdentifier: "AddJourneyRegViewController") as! AddJourneyRegViewController
        }
        self.navigationController?.pushViewController(nearMeVC, animated: true)
    }
}
