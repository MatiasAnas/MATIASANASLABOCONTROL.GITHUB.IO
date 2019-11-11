#include <math.h>

const int ENCODER_PPV = 24;

const byte LED_PIN = 13;
const byte INTERRUPT_PIN = 2;
int pwmOutput = 3;

volatile unsigned int edgesCount = 0;
volatile unsigned int edgesCountBuffer = edgesCount;

const unsigned int windowInMillis = 20;
unsigned int windowCounter = windowInMillis;

unsigned int pwmCounter = 1000;
unsigned int duty = 0;

const int timeSampling = 1;
void setup() {
  // initialize the serial communication:
  pinMode(pwmOutput, OUTPUT);
  pinMode(INTERRUPT_PIN, INPUT_PULLUP);
  Serial.begin(9600);
  attachInterrupt(digitalPinToInterrupt(INTERRUPT_PIN), countEdges, CHANGE);
  analogWrite(pwmOutput,0);
}


void loop() { 
  if(windowCounter < millis()) {
    windowCounter += windowInMillis;
    
    edgesCountBuffer = edgesCount;
    edgesCount = 0;
  
    float RPM = (float)edgesCountBuffer * 50.0 / ((float)ENCODER_PPV * 2.0) * 60;

    Serial.write(  highByte( (uint16_t)(RPM) )  );
    Serial.write(  lowByte ( (uint16_t)(RPM) )  );
    Serial.write(  lowByte( (uint16_t)(duty) )  );
    
    //Para el serial plotter de arduino.
    //float RPM = (float)edgesCountBuffer * 50.0 / ((float)ENCODER_PPV * 2.0) * 60;
    //float RPM = (float)edgesCountBuffer;
    //Serial.println(RPM, DEC);
  }
  if(pwmCounter < millis()) {
    analogWrite(pwmOutput,255);
    duty = 255;
    /*pwmCounter += 1000;
    if(duty == 128) {
      duty = 255;
      analogWrite(pwmOutput,255);
    } else {
      duty = 128;
      analogWrite(pwmOutput,128);
    }*/

    
  }
}

void countEdges() {
  edgesCount++;  
}
