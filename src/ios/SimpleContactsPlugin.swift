import Contacts

@objc(SimpleContactsPlugin) class SimpleContactsPlugin : CDVPlugin {
    @objc(echo:)
    func echo(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR
        )

        let msg = command.arguments[0] as? String ?? ""

        if msg.count > 0 {
            /* UIAlertController is iOS 8 or newer only. */
            let toastController: UIAlertController = UIAlertController(
                title: "", 
                message: msg,
                preferredStyle: .alert
            )
            self.viewController?.present(
                toastController, 
                animated: true, 
                completion: nil
            )
//            let duration = Double(NSEC_PER_SEC) * 3.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                toastController.dismiss(
                    animated: true,
                    completion: nil
                )
            }
            
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: msg
            )
        }

        self.commandDelegate!.send(
            pluginResult, 
            callbackId: command.callbackId
        )
    }
    
    @objc(getAllContacts:)
    func getAllContacts(command: CDVInvokedUrlCommand) {
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
        ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                    (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    let number = phoneNumber.value
                    let label = phoneNumber.label
                    let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label!)
                    print("\(contact.givenName) \(contact.familyName)\n tel:\(localizedLabel) -- \(number.stringValue),\n email: \(contact.emailAddresses)\n")
                }
            }
            print(contacts)
        } catch {
            print("unable to fetch contacts")
        }
    }
}
