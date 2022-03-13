extension SPMScanningStrategy {

    struct Package: Decodable {

        struct Dependency: Decodable {

            let scm: [SCM]?
        }

        struct SCM: Decodable {

            let identity: String
            let location: String
        }

        let dependencies: [Dependency]?
    }
}
