enum ChoiceStep {
    case popVCIsRequired
    
    //SignIn
    case signUpIsRequired
    case mainVCIsRequried
    case findPassword_phoneNumberAuth
    case findPasword_changepassword(phoneNumber: String)
    
    //SignUp
    case registrationPasswordIsRequired(phoneNumber: String)
    case userProfileInfoIsRequired(phoneNumber: String, password: String)
    
    //Main
    case addPostIsRequired
    case detailPostIsRequired(model: PostList, type: ViewControllerType)
    case profileIsRequired
    
    //AddPost
    case addImageIsRequired(title: String, content: String)
    
    //Profile
    case logOutIsRequired
    
    //lottie
    case pushCompleteViewIsRequired
}
