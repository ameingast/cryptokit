import CryptoKit

do {
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
    print("md5: \(md5Hash), sha512: \(sha512Hash), hashes: \(hashes)")

    // MARK: Partitioning
    if let data = String(repeating: "Secret Text", count: 1024 * 1024).data(using: .utf8) {
        let inputStream = InputStream(data: data)
        let outputStream = OutputStream(toMemory: ())
        var chunks: [Data] = []
        try Stream.disassemble(from: inputStream,
                               partitionStrategy: .random,
                               password: "password") { chunk in chunks.append(chunk); return true }
        try Stream.assemble(to: outputStream,
                            password: "password") { chunks.count > 0 ? chunks.removeFirst() : nil }
        let decryptedData = outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
        print(data == decryptedData)
    }
} catch {
    print(error)
}
