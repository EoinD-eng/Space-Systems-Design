//Eoin Doyle 
//13/11/2025

#include <DFRobot_BMP3XX.h>                       // Include the DFRobot_BMP3XX.h library
#include <DFRobot_GNSS.h>                         // Include the DFRobot_GNSS.h library

float temperature, Pressure, altitude;            // Create the temperature, pressure and altitude variables

DFRobot_BMP388_I2C sensor(&Wire, sensor.eSDOVDD); // Intilise sensors
DFRobot_GNSS_I2C gnss(&Wire ,GNSS_DEVICE_ADDR);

#define CALIBRATE_ABSOLUTE_DIFFERENCE             // Define Callabration of the BMP sensor

void setup() {

  Serial.begin(9600);                             // Initialise the serial port

//////// Setup for the BMP sensor///////////
  int rslt;
  while( ERR_OK != (rslt = sensor.begin()) ){
    if(ERR_DATA_BUS == rslt){
      Serial.println("Data bus error!!!");
    }else if(ERR_IC_VERSION == rslt){
      Serial.println("Chip versions do not match!!!");
    }
    delay(3000);
  }

  while( !sensor.setSamplingMode(sensor.eUltraPrecision) ){
    Serial.println("Set samping mode fail, retrying....");
    delay(3000);
  }


  

  // Callabration of the BMP sensor, height set to 10m roughly for the height of UL above sea level
  #ifdef CALIBRATE_ABSOLUTE_DIFFERENCE
  
  if(sensor.calibratedAbsoluteDifference(18.0) ){
   Serial.println("Absolute difference base value set successfully!");
   }
  #endif

  // Check if GNSS sensor is connected
  while(!gnss.begin()){

    Serial.println("NO Deivces !");

    delay(1000);
  }
  // Intlitlise  GNSS sensor
  gnss.enablePower(); 
  gnss.setGnss(eGPS_BeiDou_GLONASS);
  gnss.setRgbOn();
  
  Serial.println("Begin ok!");
}

 
void loop() {

  // Pull the data for the BMP388 Board //
  temperature = sensor.readTempC();
  Pressure = sensor.readPressPa();
  altitude = sensor.readAltitudeM();

  //Pull data from the GNSS Board //
  sTim_t utc = gnss.getUTC();                     
  sTim_t date = gnss.getDate();
  sLonLat_t lat = gnss.getLat();
  sLonLat_t lon = gnss.getLon();
  double high = gnss.getAlt();
  uint8_t starUserd = gnss.getNumSatUsed();
  double sog = gnss.getSog();
  double cog = gnss.getCog();

// Display Data To Serial Port at 9600 bud rate and RTX Transmitter//

  Serial.print("  Date: ");
  Serial.print(date.year);
  Serial.print("/");
  Serial.print(date.month);
  Serial.print("/");
  Serial.println(date.date);
  Serial.print("  Time: ");
  Serial.print(utc.hour);
  Serial.print(":");
  Serial.print(utc.minute);
  Serial.print(":");
  Serial.println(utc.second);
  Serial.println();

  //BMP 388 Board Data// 
  Serial.println("             BMP388 Board Data          ");     
  Serial.println("| Temperature  |  Pressure  |  Altitude  |");
  Serial.print("|    ");
  Serial.print(temperature);
  Serial.print("*C   | ");
  Serial.print(Pressure);
  Serial.print("Pa |   ");
  Serial.print(altitude);
  Serial.println("m   |");
  Serial.println();
  Serial.println();
  
  //GNSS board Data//

  Serial.println("                GNSS Board Data          ");
  Serial.println("|    Latitude   |   Longitude  |  Altitude  |");
  Serial.print("|       ");
  Serial.print((char)lon.lonDirection);
  Serial.print("       |      ");
  Serial.print((char)lat.latDirection);
  Serial.println("       |            |");

  Serial.print("| ");
  Serial.print(lat.latitudeDegree,6);
  Serial.print(" deg | ");
  Serial.print(lon.lonitudeDegree,6);
  Serial.print(" deg |   ");
  Serial.print(high);
  Serial.println("m   |");
  Serial.println();

  Serial.print("Satellites Used =  ");
  Serial.println(starUserd);
  Serial.print("Speed Over Ground =  ");
  Serial.println(sog);
  Serial.print("Course Over Ground = ");
  Serial.println(cog);
  Serial.print("gnss mode =  ");
  Serial.println(gnss.getGnssMode());
  Serial.println();

  delay(2000);


}