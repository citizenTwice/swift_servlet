/*

 Coded by LuigiG | 2019 | LG@citizentwice.nl

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


Reference:
https://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html


*/

#include <jni.h>
#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

void  *jni_get_class_from_name(JNIEnv *jenv, const char *name) {
    return (*jenv)->FindClass(jenv, name);
}

void *jni_new_string(JNIEnv *jenv, const char *str) {
    return (*jenv)->NewStringUTF(jenv, str);
}

void *jni_get_method_id(JNIEnv *jenv, jclass cls, const char *method_name, const char *method_sig) {
    return (*jenv)->GetMethodID(jenv, cls, method_name, method_sig);
}

void *jni_call_method_0arg(JNIEnv *jenv, jobject jobj, jmethodID jm ) {
    return (*jenv)->CallObjectMethod(jenv, jobj, jm );
}

void *jni_call_method_1arg(JNIEnv *jenv, jobject jobj, jmethodID jm, jobject jarg1 ) {
    return (*jenv)->CallObjectMethod(jenv, jobj, jm, jarg1 );
}

void *jni_call_method_2arg(JNIEnv *jenv, jobject jobj, jmethodID jm, jobject jarg1, jobject jarg2 ) {
    return (*jenv)->CallObjectMethod(jenv, jobj, jm, jarg1, jarg2 );
}

const char *jni_jstr_to_utf8(JNIEnv *jenv, jstring js) {
    // warning : copy the chars and release the buffer ASAP - otherwise: leak!
    return (*jenv)->GetStringUTFChars(jenv, js, 0);
}

void jni_release_utf8(JNIEnv *jenv, jstring jstr, const char *utf8) {
    (*jenv)->ReleaseStringUTFChars(jenv, jstr, utf8);
}

void *jni_cstr_to_byte_array(JNIEnv *jenv, const char *s) {
    jbyteArray ba = (*jenv)->NewByteArray(jenv, strlen(s) + 1);
    jboolean t;
    jbyte *aptr = (*jenv)->GetByteArrayElements(jenv, ba, &t);
    const char *psrc = s;
    char *pdest = (char*) aptr;
    while(*psrc != 0) {
        *pdest++ = *psrc++;
    }
    *pdest++ = 0;
    (*jenv)->ReleaseByteArrayElements(jenv, ba, aptr, 0);
    return (void*)ba;
}


bool jni_is_null(jobject jobj) {
    return (jobj == NULL);
}