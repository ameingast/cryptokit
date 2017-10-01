import Cocoa
import CryptoKit

// MARK: Encryption
do {
    if let data = "Secret Text".data(using: String.Encoding.utf8) as NSData? {
        let encrypted = try data.encryptedData(withPassword: "secret") as NSData
        let decrypted = try encrypted.decryptedData(withPassword: "secret") as NSData
        let plain = String.init(data: decrypted as Data, encoding: String.Encoding.utf8)

        print(plain!)

        let recrypted = try encrypted.recryptData(withPassword: "secret", newPassword: "newSecret") as NSData
        let recryptDecrypted = try recrypted.decryptedData(withPassword: "newSecret") as NSData
        let recryptedPlain = String.init(data: recryptDecrypted as Data, encoding: String.Encoding.utf8)

        print(recryptedPlain!)
    }
} catch {
    print(error)
}

// MARK: Digests
let md5Hash = "123".md5HexHash()
let sha512Hash = "123".sha512HexHash()
