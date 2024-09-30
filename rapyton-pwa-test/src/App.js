import logo from './logo.svg';
import './App.css';
import { useState, useEffect } from 'react';
import { SnackbarProvider, enqueueSnackbar } from 'notistack';

import RapytonBridge from 'rapyton-pwa-bridge/rapytonbridge';

function App() {

  const [phoneNumber, setPhoneNumber] = useState('');
  const [messageText, setMessageText] = useState('');



  useEffect(() => {
    const toastttt = () => enqueueSnackbar('That was easy!', {variant: 'error', persist: true});
    
    const rapytonBridge = new RapytonBridge();

    rapytonBridge.onCancelled((messageId)=>{toastttt()});
    rapytonBridge.onSent((messageId)=>{toastttt()});
    rapytonBridge.onFailed((messageId)=>{toastttt()});
    rapytonBridge.onUnknownError((messageId)=>{toastttt()});

    // Cleanup the listeners when component unmounts
    return () => {
      rapytonBridge.clearCallbacks();
    };
  }, []);

  const sendSms = ()=>{
    if (phoneNumber && messageText) {
      const rapytonBridge = new RapytonBridge();
      rapytonBridge.sendMessageToSwift(phoneNumber, messageText);
    }
  }

  return (
    <div className="App">
      <header className="App-header">
       <SnackbarProvider />
        <img src={logo} className="App-logo" alt="logo" />
        <input style={{width: "200px",height: "50px",fontSize: "large"}} placeholder="phone number" onChange={e => setPhoneNumber(e.target.value)} />
        <br/>
        <input style={{width: "300px",height: "50px",fontSize: "large"}} placeholder="text message" onChange={e => setMessageText(e.target.value)} />
        <br/>
        <button style={{width: "200px",height: "50px",fontSize: "large"}} type="submit" onClick={sendSms}>send message</button>
      </header>
    </div>
  );
}

export default App;
