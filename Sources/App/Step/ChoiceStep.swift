enum ChoiceStep {
    case popVCIsRequired
    
    //siginIn
    case signUpIsRequired
    case mainVCIsRequried
    
    //Main
    case addPostIsRequired
    case detailPostIsRequired(model: PostModel)
    case profileIsRequired
    
    //AddPost
    case popAddpostIsRequired
    
    //Profile
    case logoutIsRequired
}
