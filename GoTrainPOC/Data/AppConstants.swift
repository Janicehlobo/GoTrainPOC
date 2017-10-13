//
//  Constants.swift
//  HCMA
//
//  Created by Bahram Haddadi on 2017-03-06.
//  Copyright © 2017 IBM Canada. All rights reserved.
//

import UIKit

// MARK: - enums
enum ToastStyleType: Int {
    case `default`
    case information
    case warning
    case error
    case criticalError
}

enum MapAppNames: String {
    case appleMap = "Open Apple Map"
    case googleMap = "Open Google Map"
}

enum MapOverLayState: String {
    case close
    case halfOpen
    case wideOpen
}

enum SiteDetailRowButtonType {
    case none
    case phone
    case share
    case email
}

enum SimpleTableCellAccessoryType: Int {
    case none
    case disclosureIndicator
    case detailDisclosureButton
    case checkmark
    case badge
    case rightAlignDetail
    case twoColumns
    case rightAlignDetailWithDisclosure
}

enum CardType: Int {
    case unknown = -1
    case visaCard = 0
    case masterCard = 1
    case americanExpress = 2
    case applePay = 201
    case giftCard = 101
}

enum OfferType: Int {
    case unknown = -1
    case loyalty = 1
    case pricebook = 2
    case combined = 3
}

enum OfferCategory: Int {
    case unknown = -1
    case saltySnacks = 1
    case confectionery = 2
    case carWash = 3
    case lottery = 4
    case hotBeverages = 5
    case coldSucks = 6
    case meatSnacks = 7
    case dairy = 8
}

enum OfferCellPosition {
    case center
    case left
    case right
}

enum OfferActionType {
    case share
    case like
    case unLike
    case hide
}

enum PayAtPumpErrorType {
    case noAppAccount
    case appAccountNotVerified
    case noLocationService
    case checkInFailed
    case noMobilePay
    case atHome
    case expiredPaymentMothod
    case unKnown
}

enum PayAtPumpCellDataType {
    case products
    case reward
    case redeemFail
    case total
    case paymentType
}

enum LoyaltyStatus: Int {
    case unregistered = 0
    case pending = 1
    case registered = 2
    case suspended = 3
    case inactive = 4
}

enum RewardTransactionType: Int {
    case unknown = -1
    case earned = 0
    case redeemed = 2
}

class AppConstants {
    // MARK: constants with values
    static let toastAnimateTime = 0.5                           // seconds
    static let toastStayOnScreenTime = 1.0                      // seconds
    static let networkDelayTime = 0.6;                          // seconds
    static let filterTableSectionHeaderHieght: CGFloat = 56.0;  // default table header height
    static let appAdapterTimeoutSeconds = 30.0                  // number of seconds for service timeout
    static let appLocale = "en-CA"                              // default application locale
    static let googleMapURL = "comgooglemaps://"                // for linking to external app
    static let appleMapURL = "http://maps.apple.com/maps"       // for linking to external app
    static let defaultMapRadius: Double = 25                    // default radius for map to display
    static let mapReloadDelta = 0.00000001                      // call api if map moves as much as delta
    static let milesToKms = 1.60934                             // miles to kms ratio
    static let validPasswordLength = 8                          // min characters for password
    static let loggedInScope = "isLoggedIn"                     // scope used on MVP for checking login
    static let loggedInScopeSC = "UserLoginCheck"
    static let validatedAccountScope = "isValidatedAccount"     // scope used on MVP for checking if email is validated
    static let validatedAccountScopeSC = "UserValidatedEmailCheck"
    static let isEmailChangeScope = "isPasswordChecked"         // check password
    static let isEmailChangeScopeSC = "UserPasswordCheck"
    static let logoutTimeInBackgroundMode = 5.0 * 60.0          // (5 minutes) logout time if app stays in backgound mode more that defined time
    static let minOffersToShow = 2                              // min number of offer categories the user must have enable to show
    static let deiselPrefsId = 100000                               // id to use for user prefs deisel highlighter
    static let minAuthAmount = 1                                // minimum amount of payment
    static let fillAuthAmount = 200                             // maximum amount of payment
    static let currencyCode = "USD"                             // app's currency code
    static let loyaltyCardLength = 16                           // length of loyalty card numbers
    static let annotationSizeForCheckin = 50.0                  // size of pump icon on map (check-in screen)
    static let transactionTimeOut = 90                          //transaction timeout in secinds
    
    // MARK: links
    static let giftCardRegistrationLink = "https://www.kesm.net/loyalmarkapi/popups/HuskyLogin.htm"
    static let huskyRewardsLink = "http://www.myHuskyRewards.ca/"
    static let huskyLink = "http://www.myHusky.ca/"
    static let huskyProLink = "http://www.HuskyPro.ca/"
    static let rewardsForgotPasswordLink = "https://www.myhuskyrewards.ca/PasswordRecovery.aspx"
    static let customerSupportPhone = "1-855-694-8759"
    
    // MARK: string constants
    static let selectedFilters = "SelectedFilters"
    static let termsAndConditionsHasAccepted = "TermsAndConditionsAccepted"
    static let userLoginAttemptError = "userLoginAttemptError"
    static let userLoginSubmitAnswer = "userLoginSubmitAnswer"
    static let userLoginChallengeReceived = "userLoginChallengeReceived"
    static let userLoginChallengeSuccess = "userLoginChallengeSuccess"
    static let userLoginChallengeFailure = "userLoginChallengeFailure"
    static let userLoginChallengeFailureForbidden = "userLoginChallengeFailureForbidden"
    static let userLogout = "userLogout"
    static let userLogoutSuccess = "userLogoutSuccess"
    static let userLoggedIn = "userLoggedIn"
    static let userLoginSubmitCancel = "userLoginSubmitCancel"
    static let userLoginPassAutoLogin = "userLoginPassAutoLogin"
    static let hasFavoriteLoadedSuccessfully = "FavoritesLoadedSuccessfully"
    static let validatedAccountChallengeSuccess = "validatedAccountChallengeSuccess"
    static let validatedAccountChallengeFailure = "validatedAccountChallengeFailure"
    static let validatedAccountLogout = "validatedAccountLogout"
    static let changeEmailChallengeReceived = "changeEmailChallengeReceived"
    static let changeEmailSubmitAnswer = "changeEmailSubmitAnswer"
    static let changeEmailChallengeSuccess = "changeEmailChallengeSuccess"
    static let changeEmailChallengeFailure = "changeEmailChallengeFailure"
    static let changeEmailChallengeCancel = "changeEmailChallengeCancel"
    static let changeEmailLogout = "changeEmailLogout"
    static let backgoundTime = "BackgroundTime"
    static let logoutOnTerminate = "LogoutOnTerminate"
    static let favorites = "Favorites"
    static let userPreferences = "userPreferences"
    static let preferencesChanged = "preferencesChanged"
    static let hiddenOffers = "hidenOffers"
    static let favoriteOffers = "favoriteOffers"
    static let fuelStarted = "fuelStarted"
    static let fuelCancelled = "fuelCancelled"
    static let fuelCompleted = "fuelCompleted"
    static let fuelReceipt = "fuelReceipt"
    
}
