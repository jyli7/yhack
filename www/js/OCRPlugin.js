var OCRPlugin = { 
	callNativeFunction: function (success, fail, resultType) { 
 
		return cordova.exec( success, fail, "com.jcesarmobile.OCRPlugin", "recogniseOCR", [resultType]); 
		} 
	};