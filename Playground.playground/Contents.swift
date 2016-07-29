import Cocoa
import CryptoKit

// MARK: Encryption
do {
    if let data = "Secret Text".dataUsingEncoding(NSUTF8StringEncoding) {
        let encrypted = try data.encryptedDataWithPassword("secret")
        let decrypted = try encrypted.decryptedDataWithPassword("secret")
        let plain = String.init(data: decrypted, encoding: NSUTF8StringEncoding);

        let recrypted = try encrypted.recryptDataWithPassword("secret", newPassword: "newSecret")
        let recryptDecrypted = try recrypted.decryptedDataWithPassword("newSecret")
        let recryptedPlain = String.init(data: recryptDecrypted, encoding: NSUTF8StringEncoding)
    }
} catch {
    print(error)
}

// MARK: Digests
let md5Hash = "123".md5HexHash()
let sha512Hash = "123".sha512HexHash()

