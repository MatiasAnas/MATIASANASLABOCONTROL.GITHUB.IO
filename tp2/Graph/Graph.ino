#include <math.h>

const int ENCODER_PPV = 24;

const byte LED_PIN = 13;
const byte INTERRUPT_PIN = 2;
int pwmOutput = 3;

volatile unsigned int edgesCount = 0;
volatile unsigned int edgesCountBuffer = edgesCount;

const unsigned int windowInMillis = 20;
unsigned long windowCounter = windowInMillis;

unsigned int pwmCounter = 1000;
unsigned int duty = 0;

const int timeSampling = 1;

float Ik = 0;

//float kp = 0.16819;
//float ki = 37.31;

//float kp = 0.13;
//float ki = 5;
//uint8_t nkp = 13;
//uint8_t nki = 5;
//uint8_t nkd = 0;

float kp = 0;
float ki = 0;
uint8_t nkp = 0;
uint8_t nki = 0;
uint8_t nkd = 0;
uint8_t N = 0;

uint8_t reference_high;
uint8_t reference_low;

float reference = 2000;

void setup() {
  // initialize the serial communication:
  pinMode(pwmOutput, OUTPUT);
  pinMode(INTERRUPT_PIN, INPUT_PULLUP);
  Serial.begin(115200);
  attachInterrupt(digitalPinToInterrupt(INTERRUPT_PIN), countEdges, CHANGE);
  analogWrite(pwmOutput,0);
}


void loop() { 
  if(windowCounter < millis()) {
    windowCounter += windowInMillis;
    
    edgesCountBuffer = edgesCount;
    edgesCount = 0;

    //Para enviar a MATLAB.
    float RPM = (float)edgesCountBuffer * 50.0 / ((float)ENCODER_PPV * 2.0) * 60;

    pidUpdate(RPM);
    pidOutput(RPM);

    if (Serial.available() >= 10) {
      char a = Serial.read();
      char b = Serial.read();
      char c = Serial.read();
      char d = Serial.read();
      if((a == 'a') && (b == 'b') && (c == 'c') &&(d == 'd')) {
        nkp = Serial.read();
        nki = Serial.read();
        nkd = Serial.read();
        reference_high = Serial.read();
        reference_low  = Serial.read();
        reference = reference_high * 256 + reference_low;
        N = Serial.read();
      } else {
        while(Serial.available() > 0) {
          char t = Serial.read();
        }
      }
    }

    kp = 0.01 * (float)nkp;
    ki = 1 * (float)nki;

    Serial.print("efgh");
    Serial.write(nkp);
    Serial.write(nki);
    Serial.write(nkd);
    Serial.write(  highByte( (uint16_t)(reference) )  );
    Serial.write(  lowByte ( (uint16_t)(reference) )  );
    Serial.write(  lowByte ( (uint16_t)(duty) )  );
    Serial.write(  highByte( (uint16_t)(RPM) )  );
    Serial.write(  lowByte ( (uint16_t)(RPM) )  );

    /*****************************************************************/
    
    //Para el ide de Arduino.
    //float RPM = (float)edgesCountBuffer * 50.0 / ((float)ENCODER_PPV * 2.0) * 60;

    //pidUpdate(RPM);
    //pidOutput(RPM);
    

    //Para identificacion con ide de Arduino.
    /*if(2000 > millis()) {
      Serial.print(millis(), DEC);
      Serial.print(",");
      Serial.print(duty, DEC);
      Serial.print(",");
      Serial.println(RPM, DEC);
    }*/
    
    //Para serial plotter del ide de Arduino.
    //Serial.println(RPM, DEC);

    /*****************************************************************/
  }
}

void countEdges() {
  edgesCount++;  
}

void pidUpdate(float RPM) {
  float Ikp1 = Ik + kp * ki * windowInMillis * (reference - RPM) / 1000;
  Ik = Ikp1;
}

void pidOutput(float RPM) {
  float Pk = kp * (reference - RPM);
  float output = Pk + Ik;
  int PWM = round(output);
  if(PWM > 255) {
    PWM = 255;
  } else if(PWM < 0) {
    PWM = 0;
  }
  analogWrite(pwmOutput, PWM);
  duty = PWM;
}
