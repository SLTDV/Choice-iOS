struct RequestSignInModel: Encodable {
    var phoneNumber: String
    var password: String
    var fcmToken: String?
}
