enum ChoiceStep {
    case popVCIsRequired
    
    //siginIn
    case signUpIsRequired
    case mainVCIsRequried
    
    //siginUp
    case UserInformationIsRequired
    
    //Main
    case addPostIsRequired
    case detailPostIsRequired(model: PostModel)
    case profileIsRequired
    
    //AddPost
    case popAddpostIsRequired
    
    //Profile
    case logOutIsRequired
}
