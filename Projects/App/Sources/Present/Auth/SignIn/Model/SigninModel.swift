struct SigninRequestModel: Encodable {
    var phoneNumber: String
    var password: String
    var deviceToken: String?
}
