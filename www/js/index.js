/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
<<<<<<< HEAD
=======
        this.setupTranslationButton();
>>>>>>> 59781c5491dff2aea89000e7edf15f7365d0f88c
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'app.receivedEvent(...);'
    onDeviceReady: function() {
<<<<<<< HEAD
        function onPhotoURISuccess(imageURI) {
            callNativePlugin({url_imagen: imageURI});
        }


        function callNativePlugin( returnSuccess ) { 
            OCRPlugin.callNativeFunction( nativePluginResultHandler, nativePluginErrorHandler, returnSuccess ); 
        } 

        function nativePluginResultHandler (result) { 
            alert("ok: "+result);
        } 

        function nativePluginErrorHandler (error) { 
            alert("error: "+error);
        }
        onPhotoURISuccess('img/sample.png');
        app.receivedEvent('deviceready');
=======
        app.receivedEvent('deviceready');
    },

    translateStuff: function (myPhrase) {
      $.ajax({
        url: "https://www.googleapis.com/language/translate/v2?key=AIzaSyDfmyoOXccawF9ntFmRgP6khdFNzYj6HII&source=zh-CN&target=en&q=" + encodeURIComponent(myPhrase),
        success: function (response) {
          alert(response.data.translations[0].translatedText);
        }
      });
    },

    setupTranslationButton: function () {
      var that = this;
      $('.submit').on('click', function (e) {
          var myPhrase = $('.my-phrase').val();
          that.translateStuff(myPhrase);
      });
>>>>>>> 59781c5491dff2aea89000e7edf15f7365d0f88c
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};
