var exec = require('cordova/exec');

exports.echo = function(arg0, success, error) {
    exec(success, error, "SimpleContactsPlugin", "echo", [arg0]);
};

exports.getAllContacts = function(arg0, success, error) {
	exec(success, error, "SimpleContactsPlugin", "getAllContacts", [arg0]);
};