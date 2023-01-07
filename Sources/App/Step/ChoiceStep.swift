enum ChoiceStep {
    case popVCIsRequired
    
    //siginIn
    case signUpIsRequired
    case mainVCIsRequried
    
    //Main
    case addPostIsRequired
    case detailPostIsRequired(model: PostModel)
    
    //AddPost
    case popAddpostIsRequired
}
