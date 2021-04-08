//
//  Constants.swift
//  Advantage
//
//  Created by Narender Kumar on 12/03/21.
//  Copyright © 2020 Shreehari Bhat. All rights reserved.
//

import UIKit
import Foundation
struct Constants {
    
    // MARK: AppName
    static let appName: String = "Kumbhdwar"
    static let BaseUrl = Env.Domain
    
    static let introductionUrl = "https://www.haridwarkumbhmela2021.com/about-kumbh/introduction/"
    static let attractionsUrl = "https://www.haridwarkumbhmela2021.com/nearby-attractions/"
    static let howToReachUrl = "https://www.haridwarkumbhmela2021.com/1623-2/"
    static let accommodationUrl = "https://www.yatra.com/india-tourism/haridwar/how-to-reach#:~:text=Nearest%20Airport%3A%20Jolly%20Grant%20Airport,via%20bus%2C%20taxi%20or%20train"
    struct Env {
        //Pre-Prod
        //static let Domain = " "
        //development
//        static let Domain = "http://kumbhapi.ecosmartdc.com/api/"
//        static let Domain = "http://kumbhdwar-api.haridwarkumbhmela2021.com:8081/api/"
        static let Domain = "https://kumbhdwar-api.haridwarkumbhmela2021.com/api/"

        //Prod
        //static let Domain = " "
        //---------------------------------------------------------------------------------------------------//
        
    }
    
    // MARK: ErrorMessages
    struct ErrorMessages {
        // Network Errors
        static let networkDisconnected: String = "No internet connection available."
        static let networkError: String = "Server is not responding."
        static let loadingError: String = "Could not load page."
        static let sessionExpireError: String = "Your session has expired."
        static let responseParsingError: String = "Couldn't parse the response"
        static let loginFailed: String = "Sorry, we can't log you in right now."
        static let singupFailed: String = "An error occurred while sign up."
        static let imageUploadFailed: String = "Image couldn't be uploaded."
        static let imageUploadSuccess: String = "image uploaded successfully"
        static let serverConnectionError: String = "Couldn't connect to server"
        
        // Validation Errors
        static let emptyPassword: String = "Please enter password."
        static let emptyPhone: String = "Please enter phone number."
        
        // API Error
        static let unableToGetDataList: String = "Unable to get list. Please try after some time."
        static let dataNotFound: String = "Data not found"
        static let responseError: String = "Response error"
        static let dataNotSave: String = "Unable to save data in database"
    }
    
    // MARK: APIServices
    struct APIServices {
        static let Login = Constants.APIServices.apiURL ("citizen/Login")
        static let Signup = Constants.APIServices.apiURL ("citizen/SignUp")
        static let ModeOfCommute = Constants.APIServices.apiURL ("citizen/GetAllModeOfCommute")
        static let GetOTPforAddUser = Constants.APIServices.apiURL ("KumbhApp/CheckUserInApp")
        static let AddUserToTrackGroup = Constants.APIServices.apiURL ("KumbhApp/AddUserToTrackGroup")
        static let DataById = Constants.APIServices.apiURL("KumbhApp/GetAllAmenityGeoDataById")
        static let saveCarLocation = Constants.APIServices.apiURL("JourneyPlanner/SaveMyCarLocation")
        static let addComplaint = Constants.APIServices.apiURL("Citizen/AddComplaint")
        static let getAllComplaint = Constants.APIServices.apiURL("Citizen/GetAllComplaint")
        static let saveJourney = Constants.APIServices.apiURL("JourneyPlanner/SaveAndUpdateJourneyPlan")
        static let getMyCarLocation = Constants.APIServices.apiURL("JourneyPlanner/GetMyCarLocation?VisitorId=")
        static let getalluserTrackInfo = Constants.APIServices.apiURL("KumbhApp/GetAllUserTrackInfo")
        static let getAttendance = Constants.APIServices.apiURL("Employee/mGetEmployeeAttendance")
        static let getSOSlist = Constants.APIServices.apiURL("Citizen/GetAllToFreeNo")

        static let getAllPlannerList = Constants.APIServices.apiURL("JourneyPlanner/GetMyJourneyPlan?VisitorId=")
        static let getAllPlannerPhaseWise = Constants.APIServices.apiURL("JourneyPlanner/GetAllJourneyPlanPhaseWise")
        static let deletePlanner = Constants.APIServices.apiURL("JourneyPlanner/DeleteJourneyPlanById?JourneyPlanId=")
        static let deleteTracker = Constants.APIServices.apiURL("JourneyPlanner/DeleteJTrackPersonById?UserTrackPId=")
        static let getAllAkhada = Constants.APIServices.apiURL("Amenities/GetAllAkhadaInfo")
        static let getAllAccommodation = Constants.APIServices.apiURL("Amenities/GetAllAccomodationInfo")
        static let getMyAssignedTask = Constants.APIServices.apiURL("UserTask/GetMyAssignedTask")
        static let getAllOfficialNo = Constants.APIServices.apiURL("JourneyPlanner/GetAllOfficialNo")
        static let spGetMyLeave = Constants.APIServices.apiURL("UserTask/spGetMyLeave")
        static let pushBiometricData = Constants.APIServices.apiURL("Employee/PushBiometricData")
        static let requestLeave = Constants.APIServices.apiURL("UserTask/RequestLeaveByLoginId")
        static let sosPushService = Constants.APIServices.apiURL("KumbhApp/PushSOSInfo")
        static func apiURL(_ methodName: String) -> String {
            return BaseUrl + methodName
        }
    }
    
    struct Google {
        static let ApiKey = "AIzaSyBkbFZnaMrHcaSgmPWle6Mv5e5eVwP-Hww"
    }
    
    struct ResponseKeys {
        static let success = "success"
        static let status = "status"
        static let result = "result"
        static let message = "message"
        static let totalPages = "totalPages"
        static let totalCount = "totalCount"
        static let currentPage = "currentPage"
        static let cartCount = "cartCount"
        static let numberOfResults = "numberOfResults"
        static let contentList = "contentList"
        static let data = "data"
        static let contactUser = "contactUser"
        static let look = "look"
        static let liked = "liked"
        static let name = "name"
        static let notFetchedCount = "notFetchedCount"
        static let textCampaignDelay = "textCampaignDelay"
    }
    
    // MARK: AlertTitleMessages
    struct AlertActionTitles {
        static let alertActionTrue = "Yes"
        static let alertActionFalse = "No"
        static let alertActionDelete = "Delete"
        static let alertActionFlag = "Flag"
        static let alertActionEdit = "Edit"
        static let alertActionCancel = "Cancel"
        static let alertActionReport = "Report"
        static let alertContactAdmin = "Contact Admin"
        static let alertActionUnfollow = "Unfollow"
        static let alertReportChat = "Report User"
        static let alertDeleteChat = "Delete Chat"
    }
    
    struct AlertTitles {
        static let repcardTitle = "RepCard"
        static let errorTitle = repcardTitle
        static let warningTitle = "Warning"
        static let logoutTitle = "Logout"
        static let successTitle = "Success"
        static let confirmationTitle = "Please Confirm"
        static let passwordTitle = "Enter Password"
        static let deleteTitle = "Delete!"
        static let flagTitle = "Flag!"
    }
    struct StroyboardFiles {
        static let dashboard = "Dashboard"
        static let staff = "Staff"

    }
    
    struct StoryboardIdentifiers {
        static let dashboardVC = "DashboardVC"
        static let introductionVC = "IntroductionVC"
        static let parkingVC = "ParkingVC"
        static let raiseFeedbackVC = "RaiseFeedbackVC"
        static let feedbackStatusVC = "FeedbackStatusVC"
        static let journeyPlannerVC = "JourneyPlannerVC"
        static let trackerList = "TrackerList"
        static let akhadaVC = "AkhadaVC"
        static let accommodationVC = "AccommodationVC"
        static let imageVC = "ImageVC"
        static let staffVC = "StaffVC"
        static let attendanceVC = "AttendanceVC"
        static let taskVC = "TaskVC"
        static let leaveVC = "LeaveVC"
        static let officialNo = "OfficialNoVC"
        static let applyLeaveVC = "ApplyLeaveVC"
        
        static let dashboardCell = "DashboardCollectionCell"
        static let imagesCell = "ImagesCell"
        static let socialIntegraionCell = "SocialIntegraionCell"
        static let parkingCell = "ParkingCell"
        static let feedbackStatusCell = "FeedbackStatusCell"
        static let journeyCell = "JourneyCell"
        static let trackerCell = "TrackerCell"
        static let akhadaCell = "AkhadaCell"
        static let accommodationCell = "AccommodationCell"
        static let staffCollectionCell = "StaffCollectionCell"
        static let imagesCollectionCell = "ImagesCollectionCell"
        static let attendanceCell = "AttendanceCell"
        static let taskCell = "TaskCell"
        static let leaveCell = "LeaveCell"
        static let officialCell = "OfficialCell"

    }
    
}




struct AppStyleGuide {
    // MARK: Colors
    
    struct NewUI {
        
        
        fileprivate static let themeBlue: UIColor = UIColor(hexColorCode: "#4FBBFE", alpha: 1.0)
        fileprivate static let bluishGray: UIColor = UIColor(hexColorCode: "#D3DCE6", alpha: 1.0)
        
        struct Colors {
            static let loginBg: UIColor = UIColor(hexColorCode: "CD512A", alpha: 1.0)
            static let appBg: UIColor =  UIColor(red: 236.0 / 255.0, green: 92.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
            
            static let rcTextFieldActive: UIColor = themeBlue
            static let rcTextFieldInactive: UIColor = bluishGray
            static let rcTextFieldPlaceholder: UIColor = UIColor(hexColorCode: "8492A5", alpha: 1.0)
            static let rcTextFieldUnderlineInactive: UIColor = UIColor(hexColorCode: "8492A5", alpha: 1.0)
            static let rcTextFieldUnderlineActive: UIColor = themeBlue
            static var viewBackgroundColor: UIColor {
                return UIColor.white
            }
            static var campaginSettingBtnColor: UIColor {
                return UIColor(red: 0.0, green: 0.694, blue: 0.518, alpha: 1)
            }
            static var campaginSettingConfirmBtnColor: UIColor {
                return UIColor(red: 0.31, green: 0.733, blue: 0.996, alpha: 1)
            }
            static var deliveryMethodBtnColor: UIColor {
                UIColor(red: 47.0 / 255.0, green: 127.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.0)
            }
        }
        
    }
    
    struct RatingColors {
        static let rateOne: UIColor = UIColor(red: 248.0 / 255.0, green: 135.0 / 255.0, blue: 37.0 / 255.0, alpha: 1.0)
        static let rateTwo: UIColor = UIColor(red: 255.0 / 255.0, green: 170.0 / 255.0, blue: 117.0 / 255.0, alpha: 1.0)
        static let rateThree: UIColor = UIColor(red: 118.0 / 255.0, green: 143.0 / 255.0, blue: 233.0 / 255.0, alpha: 0.5)
        static let rateFour: UIColor = UIColor(red: 23.0 / 255.0, green: 190.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
        static let rateFive: UIColor = UIColor(red: 97.0 / 255.0, green: 207.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
    }

    
    struct BorderColors {
        static let borderColorYellow: UIColor = UIColor(red: 1, green: 0.839, blue: 0.247, alpha: 1)
        static let borderColorBlue: UIColor = UIColor(red: 0.31, green: 0.733, blue: 0.996, alpha: 1)
        static let borderColorGreen: UIColor = UIColor(red: 0.337, green: 0.851, blue: 0.686, alpha: 1)
    }
    
}
