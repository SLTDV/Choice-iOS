enum ChoiceStep {
    case popVCIsRequired
    
    //SignIn
    case signUpIsRequired
    case mainVCIsRequried
    case findPassword_phoneNumberAuth
    
    //SignUp
    case registrationPasswordIsRequired(phoneNumber: String)
    case userProfileInfoIsRequired(phoneNumber: String, password: String)
    
    //Main
    case addPostIsRequired
    case detailPostIsRequired(model: PostList, type: ViewControllerType)
    case profileIsRequired
    
    //AddPost
    case popAddpostIsRequired
    
    //Profile
    case logOutIsRequired
}
