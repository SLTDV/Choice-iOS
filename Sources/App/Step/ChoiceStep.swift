enum ChoiceStep {
    case popVCIsRequired
    
    //SignIn
    case signUpIsRequired
    case mainVCIsRequried
    
    //SignUp
    case userProfileInfoIsRequired
    
    //Main
    case addPostIsRequired
    case detailPostIsRequired(model: PostModel)
    case profileIsRequired
    
    //AddPost
    case popAddpostIsRequired
    
    //Profile
    case logOutIsRequired
}
