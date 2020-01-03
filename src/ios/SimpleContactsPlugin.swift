import Contacts

class Contact: Codable {
    var givenName: String
    var familyName: String
    var label: String
    var localizedLabel: String
    var phoneNumber: String
    
    init(
        givenName: String,
        familyName: String,
        label: String,
        localizedLabel: String,
        phoneNumber: String
    ) {
        self.givenName = givenName
        self.familyName = familyName
        self.label = label
        self.localizedLabel = localizedLabel
        self.phoneNumber = phoneNumber
    }
}

@objc(SimpleContactsPlugin) class SimpleContactsPlugin : CDVPlugin {
    @objc(getAllContacts:)
    func getAllContacts(command: CDVInvokedUrlCommand) {
        let msg = "unable to fetch contacts"
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR,
            messageAs: msg
        )
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
        ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        var resultData: [Contact] = []
        do {
            try contactStore.enumerateContacts(with: request){
                    (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        resultData.append(
                            Contact(
                                givenName: contact.givenName,
                                familyName: contact.familyName,
                                label: label,
                                localizedLabel: localizedLabel,
                                phoneNumber: number.stringValue
                            )
                        )
                    }
                }
            }
            let jsonData = try! JSONEncoder().encode(resultData)
            let result = String(data: jsonData, encoding: .utf8)
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: result
            )
        } catch {
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: msg
            )
        }
        // Send Cordova Plugin Result To Browser
        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
}
