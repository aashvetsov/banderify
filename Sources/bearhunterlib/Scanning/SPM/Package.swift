struct Package: Decodable {

    struct Dependency: Decodable {

        struct SCM: Decodable {

            let identity: String?
            let location: String?
        }

        let scm: [SCM]?
    }

    let dependencies: [Dependency]?
}

extension Package {

    var scms: [Dependency.SCM]? {
        dependencies?
            .flatMap(\.scm)
    }
}
