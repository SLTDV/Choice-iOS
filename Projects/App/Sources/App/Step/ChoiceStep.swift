enum ChoiceStep {
    case popVCIsRequired
    
    //SignIn
    case signUpIsRequired
    case mainVCIsRequried
    
    //SignUp
    case registrationPasswordIsRequired(phoneNumber: String)
    case userProfileInfoIsRequired(phoneNumber: String, password: String)
    
    //Main
    case addPostIsRequired
    case detailPostIsRequired(model: PostList, type: ViewControllerType)
    case profileIsRequired
    
    //AddPost
    case popAddpostIsRequired
    case addImageIsRequired(title: String, content: String?)
    
    //Profile
    case logOutIsRequired
}
