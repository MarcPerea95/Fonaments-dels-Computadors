public class InputManager {
  boolean firstTime;
  int lightValue, rotatorValue, temperatureValue;
  int startTemperatureValue;
  //Timer timer;

  InputManager() {
  }

  public void Setup() {
    commSetup();
    firstTime = true;
  }

  public void Update()
  {

    if ( dataAvailable (CHANNEL_1) ) {      
      lightValue = getData(CHANNEL_1);
    }
    if ( dataAvailable (CHANNEL_2) ) {      
      rotatorValue = getData(CHANNEL_2);
    }
    if ( dataAvailable (CHANNEL_3) ) {      
      if (firstTime) {
        startTemperatureValue = getData(CHANNEL_3);
        firstTime = false;
      } else temperatureValue = getData(CHANNEL_3);
    }
  }

  public float GetSpeedOnTempChange() {
    return (temperatureValue - startTemperatureValue) * 0.25;
  }

  public void ShutDown() {
    commManager();
  }

  public float GetTemperatureValue() {
    return GetSpeedOnTempChange();
    //return map(temperatureValue, startTemperatureValue - 5, startTemperatureValue + 5, 1, 4);
  }
  public float GetRotatorValue() {
    return map(rotatorValue, 0, 1023, height - height/10, height/10);
  }
  public float GetLightValue() {
    return map(lightValue, 50, 250, height - height/10, height/10);
  }
}
