//
//  WMSessionConfigBuilder.swift
//  WebimWidget
//
//  Created by Аслан Кутумбаев on 24.04.2023.
//  
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

public class WMSessionConfigBuilder {
    let sessionConfig = WMSessionConfig()
    
    public init() { }
    
    /**
     - returns:
     `WMSessionConfig` object.
     Aslan Kutumbaev
     - copyright:
     2023 Webim
     */
    public func build() -> WMSessionConfig {
        return sessionConfig
    }
    
    /**
     Sets company account name in Webim system.
     - parameter accountName:
     Usually presented by full domain URL of the server (e.g "https://demo.webim.ru").
     For testing purposes it is possible to use account name "demo".
     - attention:
     This parameter are required! Otherwise session will not be created.
     - returns:
     `WMSessionConfigBuilder` object with session configuration.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Webim
     */
    public func set(accountName: String) -> Self {
        sessionConfig.accountName = accountName
        return self
    }
    
    /**
     Sets location in Webim system.
     - parameter location:
     Location on server.
     You can use "mobile" or contact support for creating new one. DefaultValue `"mobile"`.
     - returns:
     `WMSessionConfigBuilder` object with session configuration.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Webim
     */
    public func set(location: String) -> Self {
        sessionConfig.location = location
        return self
    }
    
    /**
     A visitor can be anonymous or authorized. Without calling this method when creating a session visitor is anonymous.
     In this case visitor receives a random ID, which is written in `WMKeychainWrapper`. If the data is lost (for example when application was reinstalled), the user ID is also lost, as well as the message history.
     Authorizing of a visitor can be useful when there are internal mechanisms of authorization in your application and you want the message history to exist regardless of a device communication occurs from.
     This method takes as a parameter a string containing the signed fields of a user in JSON format. Since the fields are necessary to be signed with a private key that can never be included into the code of a client's application, this string must be created and signed somewhere on your backend side. Read more about forming a string and a signature here: https://webim.ru/help/identification/
     - parameter visitorFieldsJSONData:
     JSON-data containing the signed fields of a visitor.
     - returns:
     `WMWidgetBuilder` object with session config.
     - SeeAlso:
     `set(visitorFieldsJSONstring:)`
     - Author:
     Aslan Kutumbaev
     - Copyright:
     2023 Webim
     */
    public func set(visitorFieldsJSONData: Data) -> Self {
        sessionConfig.visitorFieldsJSONData = visitorFieldsJSONData
        return self
    }
    
    /**
     A visitor can be anonymous or authorized. Without calling this method when creating a session visitor is anonymous.
     In this case visitor receives a random ID, which is written in `WMKeychainWrapper`. If the data is lost (for example when application was reinstalled), the user ID is also lost, as well as the message history.
     Authorizing of a visitor can be useful when there are internal mechanisms of authorization in your application and you want the message history to exist regardless of a device communication occurs from.
     This method takes as a parameter a string containing the signed fields of a user in JSON format. Since the fields are necessary to be signed with a private key that can never be included into the code of a client's application, this string must be created and signed somewhere on your backend side. Read more about forming a string and a signature here: https://webim.ru/help/identification/
     - parameter visitorFieldsJSONString:
     JSON-string containing the signed fields of a visitor.
     - returns:
     `WMWidgetBuilder` object with session config.
     - SeeAlso:
     https://webim.ru/help/identification/
     set(visitorFieldsJSONdata:)
     - Author:
     Aslan Kutumbaev
     - Copyright:
     2023 Webim
     */
    public func set(visitorFieldsJSONString: String) -> Self {
        sessionConfig.visitorFieldsJSONString = visitorFieldsJSONString
        return self
    }
    
    
    /**
     You can differentiate your app versions on server by setting this parameter. E.g. "2.9.11".
     This is optional.
     - parameter appVersion:
     Client app version name.
     - returns:
     `SessionBuilder` object with app version set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Webim
     */
    public func set(appVersion: String?) -> Self {
        sessionConfig.appVersion = appVersion
        return self
    }
}
