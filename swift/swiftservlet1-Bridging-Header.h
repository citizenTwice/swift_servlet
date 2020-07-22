/*

 Coded by LuigiG | 2019 | GIT@THLG.nl

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

#include <jni.h>
#include <stdbool.h>

void       *jni_get_class_from_name(void *jenv, const char *classname);
void       *jni_get_method_id(void *jenv, void *cls, const char *name, const char *sig);
void       *jni_call_method_0arg(void *jenv, void *job, void *met);
void       *jni_call_method_1arg(void *jenv, void *job, void *met, void *arg1);
void       *jni_call_method_2arg(void *jenv, void *job, void *met, void *arg1, void *arg2);
const char *jni_jstr_to_utf8(void *jenv, void *js);
void       jni_release_utf8(void *jenv, void *jstr, const char*utf8);
void       *jni_new_string(void *jenv, const char *str);
bool       jni_is_null(void *job);
void       *jni_cstr_to_byte_array(void *jenv, const char *s);


typedef struct {
    void *null1, *null2, *null3, *null4;
    int (*GetVersion)();
    // todo...
} _JNIENV;

