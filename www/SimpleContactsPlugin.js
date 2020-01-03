var exec = require('cordova/exec');

exports.echo = function(arg0, success, error) {
    exec(success, error, "SimpleContactsPlugin", "echo", [arg0]);
};

exports.getAllContacts = function(arg0) {
    return new Promise(function(resolve, reject) {
        exec(
            function(res) { resolve(res); }, 
            function(err) { reject(err); },
            "SimpleContactsPlugin", 
            "getAllContacts",
            [arg0]
        );
    });
}