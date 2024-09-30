class RapytonBridge {
  static _instance;
  constructor() {
    if (RapytonBridge._instance) {
      return RapytonBridge._instance;
    }
    
    this.cancelledCallbackList = [];
    this.sentCallbackList = [];
    this.failedCallbackList = [];
    this.unknownErrorCallbackList = [];

    window.javaScriptCancelled = this.javaScriptCancelled.bind(this);
    window.javaScriptSent = this.javaScriptSent.bind(this);
    window.javaScriptFailed = this.javaScriptFailed.bind(this);
    window.javaScriptUnknownErr = this.javaScriptUnknownErr.bind(this);

    RapytonBridge._instance = this;
  }

  sendMessageToSwift(recipientNumber, messageBody, messageID=0) {
    if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.nativeCallback) {
        const message = {
            recipient: recipientNumber,
            message: messageBody,
            messageID: messageID
        };
        window.webkit.messageHandlers.nativeCallback.postMessage(message);
    }
}


  onCancelled(callback) {
    this.cancelledCallbackList.push(callback);
  }
  onSent(callback) {
    this.sentCallbackList.push(callback);
  }
  onFailed(callback) {
    this.failedCallbackList.push(callback);
  }
  onUnknownError(callback) {
    this.unknownErrorCallbackList.push(callback);
  }


  clearCallbacks(){
    this.cancelledCallbackList = [];
    this.sentCallbackList = [];
    this.failedCallbackList = [];
    this.unknownErrorCallbackList = [];
  }

  

  javaScriptCancelled(messageID) {
    var onceUsed = false;
    this.cancelledCallbackList.forEach(callback => {
      if(typeof callback === 'function'){
        try{
          callback(messageID);
          onceUsed = true;
        } catch (e){}
      }
    });
    if(onceUsed){
      return messageID;
    }
    return -1;
  }

  javaScriptSent(messageID) {
    var onceUsed = false;
    this.sentCallbackList.forEach(callback => {
      if(typeof callback === 'function'){
        try{
          callback(messageID);
          onceUsed = true;
        } catch (e){}
      }
    });
    if(onceUsed){
      return messageID;
    }
    return -1;
  }

  javaScriptFailed(messageID) {
    var onceUsed = false;
    this.failedCallbackList.forEach(callback => {
      if(typeof callback === 'function'){
        try{
          callback(messageID);
          onceUsed = true;
        } catch (e){}
      }
    });
    if(onceUsed){
      return messageID;
    }
    return -1;
  }

  javaScriptUnknownErr(messageID) {
    var onceUsed = false;
    this.unknownErrorCallbackList.forEach(callback => {
      if(typeof callback === 'function'){
        try{
          callback(messageID);
          onceUsed = true;
        } catch (e){}
      }
    });
    if(onceUsed){
      return messageID;
    }
    return -1;
  }
  
  

}

export default RapytonBridge;

