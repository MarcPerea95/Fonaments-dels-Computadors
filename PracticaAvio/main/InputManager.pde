public class InputManager {
  int altitude; //Chanel 1 RECEIVE
  boolean criticalSignal; //Chanel 2 RECEIVE


  InputManager() {
    criticalSignal = false;
    altitude = 0;
  }

  public void Setup() {
    commSetup();
  }

  public void Update()
  {

    if ( dataAvailable (CHANNEL_1) ) {      
      altitude = getData(CHANNEL_1);
    }
    if ( dataAvailable (CHANNEL_2) ) {   
      int tmp = getData(CHANNEL_2);
      criticalSignal = tmp == 0 ? false : true;
    }
  }

  public void SendEngineSpeed(int modifier) {
    sendData(CHANNEL_3, modifier);
  }

  public void ShutDown() {
    commManager();
  }

  public long GetAltitude() {
    return altitude * 10000;
    //return map(temperatureValue, startTemperatureValue - 5, startTemperatureValue + 5, 1, 4);
  }
  public boolean GetCriticalSignal() {
    return criticalSignal;
  }
}
