const sqliteParser = require('sqlite-parser');

String.prototype.titleCase = function() {
    return this.split(' ').map((val) => {
        return val.charAt(0).toUpperCase() + val.substr(1).toLowerCase();
    }).join(' ');
};

String.prototype.snakeToCamel = function() {
    return this.replace(/(\_\w)/g, function(m){return m[1].toUpperCase();});
};

function isNull(definition) {
    for (var i = 0; i < definition.length; i++) {
        var def = definition[i];
        if (def.type === "constraint" && def.variant === "not null")
            return false;
    }

    return true;
}

function isPrimaryKey(definition) {
    for (var i = 0; i < definition.length; i++) {
        var def = definition[i];
        if (def.type === "constraint" && def.variant === "primary key")
            return true;
    }

    return false;
}

function getDefaultValue(definition) {
    for (var i = 0; i < definition.length; i++) {
        var def = definition[i];
        if (def.type === "constraint" && def.variant === "default")
            return def.value.value.replace(/'/g, "");
    }

    return null;
}

function parse(sql) {
    var tableData = sqliteParser(sql).statement[0];

    if (tableData.variant !== "create" && tableData.format !== "format") {
        throw new Error("This parser can only generate create table statements!");
    }

    const tableName = tableData.name.name;
    const swiftClassName = tableName.titleCase().snakeToCamel() + "Model";
    const columns = [];

    tableData.definition.forEach((columnDefinition) => {
        //console.log(`handling: ${JSON.stringify(columnDefinition)}`)
        if (columnDefinition.type == "definition" && columnDefinition.variant == "column") {
            columns.push({
                name: columnDefinition.name,
                type: columnDefinition.datatype.variant,
                isNull: isNull(columnDefinition.definition),
                isPrimaryKey: isPrimaryKey(columnDefinition.definition),
                defaultValue: getDefaultValue(columnDefinition.definition)
            });
        }
    });

    return {
        tableName: tableName,
        swiftClassName: swiftClassName,
        columns: columns
    };
}

module.exports = parse;
