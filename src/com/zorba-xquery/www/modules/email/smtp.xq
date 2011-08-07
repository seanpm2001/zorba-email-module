xquery version "3.0";

(:
 : Copyright 2006-2009 The FLWOR Foundation.
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
:)

(:~
 : This module provides functions for sending emails.
 :
 : Currently, all the errors in this module are raised under the error code
 : <code>smtp:SMTP0001</code>. Such an error is raised when it wasn't possible
 : to connect to the SMTP server. Other errors might be raised in other cases
 : as well, depending on a particular SMTP server implementation. When an error
 : is raised, the user will have to make decisions based on the error message.
 :
 : <h2>SMTP server naming conventions</h2>
 : This list is in fact section <em>III. Remote names</em> part of the UW IMAP toolkit, file
 : <a href="http://www.washington.edu/imap/documentation/naming.txt.html" target="_blank">naming.txt</a>.<br />
 :
 : All names are in the form <br />
 :  <table border="1" cellpadding="0" cellspacing="0">
 : <tbody><tr>
 : <td colspan="2"><b>remote_system_name [":" port] [flags]</b></td></tr>
 : <tr><td colspan="2">where:  </td></tr>
 : <tr><td><b>remote_system_name</b> </td><td>Internet domain name or bracketed IP address of server.</td></tr>
 : <tr><td><b>port</b></td><td>optional TCP port number, default is the default port for that service.</td></tr>
 : <tr><td><b>flags</b></td><td>optional flags, one of the following:</td></tr>
 : <tr><td><b>/user=</b></td><td>remote user name for login on the server.</td></tr>
 : <tr><td><b>/anonymous</b></td><td>remote access as anonymous user.</td></tr>
 : <tr><td><b>/secure</b></td><td>do not transmit a plaintext password over the network.</td></tr>
 : <tr><td><b>/ssl</b></td><td>use the Secure Socket Layer to encrypt the session.</td></tr>
 : <tr><td><b>/validate-cert</b></td><td>validate certificates from TLS/SSL server (this is the default behavior).</td></tr>
 : <tr><td><b>/novalidate-cert</b></td><td>do not validate certificates from TLS/SSL server, needed if server uses self-signed certificates.</td></tr>
 : <tr><td><b>/tls</b></td><td>force use of start-TLS to encrypt the session, and reject connection to servers that do not support it.</td></tr>
 : <tr><td><b>/tls-sslv23</b> </td><td>use the depreciated SSLv23 client when negotiating TLS to the server. This is necessary with some broken servers which (incorrectly) think that TLS is just another way of doing SSL </td></tr>
 : <tr><td><b>/notls</b> </td><td>do not do start-TLS to encrypt the session, even with servers that support it  </td></tr>
 : <tr><td><b>/loser</b> </td><td>disable various protocol features and perform various client-side workarounds; for example, it disables the SEARCH command in IMAP and does client-side searching instead. The precise measures taken by <b>/loser</b> depend upon the protocol and are subject to change over time. <b>/loser</b> is intended for use with defective servers which do not implement the protocol specification correctly. It should be used only as a last resort since it will seriously degrade performance </td></tr>
 : </tbody></table>
 : For example: <br />
 : <ul>
 :   <li>smtp.gmail.com:587/tls/novalidate-cert</li>
 :   <li>[209.85.129.111]:587/tls/novalidate-cert</li>
 : </ul>
 :
 : @author Sorin Nasoi, Daniel Thomas
 : @library <a href="http://www.washington.edu/imap/">c‑client Library part of UW IMAP toolkit</a>
 : @project communication
 :)
module namespace smtp = "http://www.zorba-xquery.com/modules/email/smtp";
import schema namespace imap = "http://www.zorba-xquery.com/modules/email/imap";
import schema namespace email = 'http://www.zorba-xquery.com/modules/email/email';

declare namespace ann = "http://www.zorba-xquery.com/annotations";

declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "1.0";

(:~
 : This function sends email messages from the specified account.
 :
 : @param $host-info The SMTP host, user name, and password.
 : @param $message The message to send as defined in the email XML schema.
 : @return <code>true</code> if the message was sent successfully.
 : @error SMTP0001 If any error occurs.
 : @example examples/Queries/smtp/simple_text.xq
 : @example examples/Queries/smtp/text_with_image.xq
 : @example examples/Queries/smtp/html.xq
 :)
declare %ann:sequential function smtp:send(
    $host-info as element(imap:hostInfo),
    $message as element(email:message))
  as xs:boolean
{
  smtp:send-impl(validate{$host-info}, validate{$message})
}; 

(:~
 : For internal use only.
 :
 : @param $host-info The SMTP host, username and password. This parameter has to be validated against "http://www.zorba-xquery.com/modules/email/imap" schema.
 : @param $message The message to send as defined in the email xml schema. This parameter has to be validated against "http://www.zorba-xquery.com/modules/email/email" schema.
 : @return <code>true</code> if the message was sent successfully. 
 : @error SMTP0001 If any error occurs.
 :)
declare %private %ann:sequential function smtp:send-impl(
  $host-info as element(imap:hostInfo),
  $message as element(email:message))
as xs:boolean external;
