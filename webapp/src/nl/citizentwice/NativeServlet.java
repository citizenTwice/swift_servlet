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

*/
package nl.citizentwice;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/txt2png"})
public class NativeServlet extends HttpServlet {
    static {
        // will actually look for libswiftservlet.jnilib
        System.loadLibrary("swiftservlet");
    }    

    @Override
    public native void doGet(HttpServletRequest request, HttpServletResponse response);
    
    @Override 
    public native void doHead(HttpServletRequest req, HttpServletResponse resp) ;
   
}
