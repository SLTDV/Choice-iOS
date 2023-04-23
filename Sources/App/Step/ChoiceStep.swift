enum ChoiceStep {
    case popVCIsRequired
    
    //SignIn
    case signUpIsRequired
    case mainVCIsRequried
    
    //SignUp
    case userProfileInfoIsRequired(email: String, password: String)
    
    //Main
    case addPostIsRequired
    case detailPostIsRequired(model: Posts)
    case profileIsRequired
    
    //AddPost
    case popAddpostIsRequired
    
    //Profile
    case logOutIsRequired
}
