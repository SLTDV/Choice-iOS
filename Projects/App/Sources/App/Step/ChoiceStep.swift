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
    case detailPostIsRequired(model: PostList)
    case profileIsRequired
    
    //AddPost
    case popAddpostIsRequired
    
    //Profile
    case logOutIsRequired
}
