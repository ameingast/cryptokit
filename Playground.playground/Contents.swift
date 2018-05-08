import CryptoKit

// MARK: Encryption
if let data = "Secret Text".data(using: .utf8) as NSData? {
    let encrypted = try data.encryptedData(withPassword: "secret") as NSData
    let decrypted = try encrypted.decryptedData(withPassword: "secret") as NSData
    let plain = String.init(data: decrypted as Data, encoding: .utf8)
    
    print(plain!)
    
    let recrypted = try encrypted.recryptData(withPassword: "secret", newPassword: "newSecret") as NSData
    let recryptDecrypted = try recrypted.decryptedData(withPassword: "newSecret") as NSData
    let recryptedPlain = String.init(data: recryptDecrypted as Data, encoding: .utf8)
    
    print(recryptedPlain!)
}

// MARK: Digests
let md5Hash = try "123".md5HexHash()
let sha512Hash = try "123".sha512HexHash()
let hashes = try "123".hashes()
