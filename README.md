# GRDB-Record-Generator

[![NPM](https://nodei.co/npm/grdb-record-generator.png)](https://nodei.co/npm/grdb-record-generator/)

Generates [GRDB Records](https://github.com/groue/GRDB.swift) from SQLite CREATE TABLE.

## Setup
```shell
$ [sudo] npm install grdb-record-generator -g
```

## Compatibility
GRDB 3.6+

## What it does?

Transforms this:
```sql
CREATE TABLE user (
    _id INTEGER NOT NULL PRIMARY KEY,
    name TEXT NULL DEFAULT '',
    surname TEXT NULL DEFAULT '',
    email TEXT NOT NULL,
    image TEXT NULL DEFAULT '',
    wizard_status INTEGER NOT NULL DEFAULT 0,
    color TEXT
)
```

into `UserModel.swift` (Swift 4):
```swift
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
```

## Usage
Create an sql file with a single `CREATE TABLE` statement in it (e.g. `yourfile.sql`), and execute:
```shell
grdb-record-generator yourfile.sql /outputdir
```
and you will get the resulting Swift model in the specified output directory.

## Configuration
The generator has some configuration options. It has been a choice to not add them as console parameters, to keep the usage simple and straightforward.

### Options
* `new_line_character`: Defines the character to use as a new line character for the output swift files. Defaults to `\n`.
* `indentation`: Defines how many spaces to use for a single indentation level of the output swift code. Defaults to `4`.
* `add_create_table`: if you set this to `true`, in the generated swift file you will also get a `static let createTable` with the needed SQL to create the table. Defaults to `true`.

### Where is the configuration file?
When you install the module locally, you can find the configuration at this path `./node_modules/grdb-record-generator/config.js`

When you install the module globally, the configuration resides in the global `node_modules` directory. For example, on a macOS, the `config.js` is usually located at this path: `/usr/local/lib/node_modules/grdb-record-generator/config.js`. You will need root permissions to modify it.

For more info, please check: https://stackoverflow.com/a/5926706

### How can I preserve my global config after updates?
```shell
[sudo] cp /usr/local/lib/node_modules/grdb-record-generator/config.js /tmp/grdbconfig
[sudo] npm remove grdb-record-generator -g
[sudo] npm install grdb-record-generator -g
[sudo] cp /tmp/grdbconfig /usr/local/lib/node_modules/grdb-record-generator/config.js
```
`sudo` is optional and depends on how you have installed nodejs.

## License <a name="license"></a>

    Copyright (C) 2017-2019 Aleksandar Gotev

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

