// Generated by https://github.com/gotev/GRDB-Record-Generator
import Foundation
import GRDB

class UserModel: Record {

    var _id: Int64?
    var name: String? = ""
    var surname: String? = ""
    var email: String
    var image: String? = ""
    var wizard_status: Int64 = 0
    var color: String?

    static let createTable = "CREATE TABLE \(databaseTableName) (" +
            "_id INTEGER NOT NULL PRIMARY KEY, " +
            "name TEXT NULL DEFAULT '', " +
            "surname TEXT NULL DEFAULT '', " +
            "email TEXT NOT NULL, " +
            "image TEXT NULL DEFAULT '', " +
            "wizard_status INTEGER NOT NULL DEFAULT 0, " +
            "color TEXT " +
            ") "


    override class var databaseTableName: String {
        return "user"
    }

    enum Columns {
        static let _id = Column("_id")
        static let name = Column("name")
        static let surname = Column("surname")
        static let email = Column("email")
        static let image = Column("image")
        static let wizard_status = Column("wizard_status")
        static let color = Column("color")
    }

    init(email: String) {
        self.email = email
        super.init()
    }

    required init(row: Row) {
        _id = row[Columns._id]
        name = row[Columns.name]
        surname = row[Columns.surname]
        email = row[Columns.email]
        image = row[Columns.image]
        wizard_status = row[Columns.wizard_status]
        color = row[Columns.color]
        super.init(row: row)
    }

    override func encode(to container: inout PersistenceContainer) {
        container[Columns._id] = _id
        container[Columns.name] = name
        container[Columns.surname] = surname
        container[Columns.email] = email
        container[Columns.image] = image
        container[Columns.wizard_status] = wizard_status
        container[Columns.color] = color
    }

}
