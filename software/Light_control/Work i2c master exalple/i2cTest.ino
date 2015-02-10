/*
    LM75 - An arduino library for the LM75 temperature sensor
    Copyright (C) 2011  Dan Fekete <thefekete AT gmail DOT com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <Wire.h>
//#include <LM75.h>

//LM75 sensor;  // initialize an LM75 object
// You can also initiate with another address as follows:
//LM75 sensor(LM75_ADDRESS | 0b001);  // if A0->GND, A1->GND and A2->Vcc

void setup()
{
  Wire.begin();
  Serial.begin(9600);
  Serial.println("Begin");
  Wire.begin(); // подключение к шине i2c
}

void loop()
{
  // get temperature from sensor
  Serial.print("Begin");
  Wire.requestFrom(70,2);
  
  while(Wire.available())    // пока есть, что читать
   { 
     char c = Wire.read();    // получаем байт (как символ)
     Serial.print(c);         // печатает в порт
   }
  delay(3000);
  // wake up sensor for next time around
  //sensor.shutdown(false);
  
  Serial.println();
}
