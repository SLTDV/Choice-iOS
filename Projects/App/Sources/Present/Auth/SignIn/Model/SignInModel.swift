struct SignInRequestModel: Encodable {
    var phoneNumber: String
    var password: String
    var fcmToken: String?
}
