/* 

 Coded by LuigiG | 2019 | LuigiG@4e71.org

The below code is provided for example purposes only and it is licensed under the terms of the Apache License, 
Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License. 


 JNI Reference info:
 https://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html
 https://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletResponse.html

*/

import Foundation
import CoreGraphics
import Cocoa

private func txt2PngDatUri(
    _ txt: String
) -> String {
    let W=640, H=400
    let c = NSColor(calibratedRed:0.182, green:0.182, blue:0.182, alpha:1.0)
    let text = txt
    let textRect = CGRect(x: 5, y: 5, width: W-5, height: H-5)  
    let font = NSFont(name:"Monaco", size:48.0)  
    let shadow = NSShadow()
    shadow.shadowColor = NSColor(calibratedRed:0.262, green:0.462, blue:0.854, alpha:1.0)
    shadow.shadowOffset = NSSize(width:2, height:-2)
    shadow.shadowBlurRadius = 6.5
    let parstyle = NSMutableParagraphStyle();
    parstyle.lineBreakMode = NSLineBreakMode.byWordWrapping;
    let attr  = [
        NSAttributedString.Key.font: font!, 
        NSAttributedString.Key.foregroundColor: c, 
        NSAttributedString.Key.shadow: shadow,
        NSAttributedString.Key.paragraphStyle: parstyle
    ]
    let img:NSImage = NSImage(size: NSSize(width:W, height:H))  
    img.lockFocus()
    text.draw(in: textRect, withAttributes: attr)
    img.unlockFocus()
    let imgData:Data! = img.tiffRepresentation!
    let bmp:NSBitmapImageRep! = NSBitmapImageRep(data: imgData!)
    let pngImg = bmp!.representation(using:NSBitmapImageRep.FileType.png, properties: [:])
    let datauri = "data:image/png;base64," +  pngImg!.base64EncodedString();
    return datauri
}

private func getJniVer(
    _ jenv:UnsafeMutablePointer<UnsafeMutablePointer<_JNIENV>>
) -> String {
    let jptr:UnsafeMutablePointer<UnsafeMutablePointer<_JNIENV>> = jenv;
    let tmp:Int32 = jptr.pointee.pointee.GetVersion();
    return "JNI version \(tmp)";
}

private func jstr2str(
    _ jenv:UnsafeMutableRawPointer, 
    _ jstr:UnsafeMutableRawPointer
) -> String {
    let tmp:UnsafePointer<Int8> = jni_jstr_to_utf8(jenv, jstr)
    let retval:String = String(cString:tmp)
    // cString init makes a copy of the buffer, so, we can tell JNI to release the buffer righ away
    jni_release_utf8(jenv, jstr, tmp)
    return retval
}

func str2JByteArray( 
    _ jenv:UnsafeMutableRawPointer, 
    _ s:String
) ->UnsafeMutableRawPointer {
    let cstr = (s as NSString).utf8String
    let charbuf = UnsafePointer<Int8>(cstr)
    return jni_cstr_to_byte_array(jenv, charbuf)
}

private func getOsVer(  
) -> String {
    return "\(ProcessInfo.processInfo.operatingSystemVersion)";
}

private func getReqParm(
    _ jenv:UnsafeMutableRawPointer, 
    _ jreq:UnsafeMutableRawPointer,
    _ jname:String
) -> String {
    let jclsReq:UnsafeMutableRawPointer? = jni_get_class_from_name(jenv, "javax/servlet/http/HttpServletRequest")
    let jmGetParm :UnsafeMutableRawPointer? = jni_get_method_id(jenv, jclsReq, "getParameter", "(Ljava/lang/String;)Ljava/lang/String;")
    let jval:UnsafeMutableRawPointer? = jni_call_method_1arg(jenv, jreq, jmGetParm, jni_new_string(jenv, "txt"))
    if (jval != nil) {
        return jstr2str(jenv,jval!)
    } else {
        return "none";
    }
}

private func getClientIp(
    _ jenv:UnsafeMutableRawPointer, 
    _ jreq:UnsafeMutableRawPointer
) -> String {
    let jclsReq:UnsafeMutableRawPointer? = jni_get_class_from_name(jenv, "javax/servlet/http/HttpServletRequest")
    let jmGetRA :UnsafeMutableRawPointer? = jni_get_method_id(jenv, jclsReq, "getRemoteAddr", "()Ljava/lang/String;")
    let jval:UnsafeMutableRawPointer? = jni_call_method_0arg(jenv, jreq, jmGetRA)
    if (jval != nil) {
        return jstr2str(jenv,jval!)
    } else {
        return "0.0.0.0";
    }
}

private func isLocal(
    _ ip:String
) -> Bool {
    return (ip == "127.0.0.1" || ip == "0:0:0:0:0:0:0:1" || ip == "::1")
}

@_silgen_name("Java_nl_citizentwice_NativeServlet_doHead") 
public func doHead( 
       jenv:UnsafeMutablePointer<UnsafeMutablePointer<_JNIENV>>,
       jobj:UnsafeMutableRawPointer,
       jreq:UnsafeMutableRawPointer,
       jresp:UnsafeMutableRawPointer
) -> Void {
    // naive localhost-only enforcer:
    // no further processing if request does not come from localhost
    if (!isLocal(getClientIp(jenv,jreq))) {
        return
    }
    let jclsResp = jni_get_class_from_name(jenv, "javax/servlet/http/HttpServletResponse")
    let jmAddHeader :UnsafeMutableRawPointer? =  jni_get_method_id(jenv, jclsResp, "addHeader", "(Ljava/lang/String;Ljava/lang/String;)V"   )
    jni_call_method_2arg(jenv, jresp, jmAddHeader, jni_new_string(jenv,"txt2png-input"), jni_new_string(jenv,getReqParm(jenv, jreq, "txt")))
    let tmp:String = getReqParm(jenv, jreq, "txt")
    let osv  = getOsVer();
    let jniv = getJniVer(jenv)
    // goes to catalina.out
    NSLog("SWIFT: This is JNI \(jniv) on OS \(osv) - current servlet parameter txt = \(tmp)")
    NSLog("Clinet IP is " + getClientIp(jenv, jreq))
} 

@_silgen_name("Java_nl_citizentwice_NativeServlet_doGet") 
public func doGet(
    jenv:UnsafeMutablePointer<UnsafeMutablePointer<_JNIENV>>,
    jobj:UnsafeMutableRawPointer,
    jreq:UnsafeMutableRawPointer,
    jresp:UnsafeMutableRawPointer
) -> Void {
    // no further processing if request does not come from localhost
    if (!isLocal(getClientIp(jenv,jreq))) {
        return
    }
    doHead(jenv:jenv, jobj:jobj, jreq:jreq, jresp:jresp)
    let jclsResp = jni_get_class_from_name(jenv, "javax/servlet/http/HttpServletResponse")
    let jmGetOStream :UnsafeMutableRawPointer? =  jni_get_method_id(jenv, jclsResp, "getOutputStream", "()Ljavax/servlet/ServletOutputStream;"   )
    let jclsOStream :UnsafeMutableRawPointer? = jni_get_class_from_name(jenv, "javax/servlet/ServletOutputStream")
    let jmWrite :UnsafeMutableRawPointer? =  jni_get_method_id(jenv, jclsOStream, "write", "([B)V")
    let html = "<!doctype html>\n<html><head/><body><img src='" + txt2PngDatUri(getReqParm(jenv, jreq, "txt")) + "'/>\n</body></html>"
    let ba = jni_cstr_to_byte_array(jenv, html)
    let jOut = jni_call_method_0arg(jenv, jresp, jmGetOStream)
    if (jOut == nil) {
        NSLog("OutputStream = null")
    }
    if (ba == nil) {
        NSLog("Response string cnv to ByteArray = null")
    }
    jni_call_method_1arg(jenv, jOut, jmWrite, ba)
}

