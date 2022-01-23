#include <Servo.h>

Servo motor1;
Servo motor2;

const int beltStepperPin = 9;
const int kickStepperPin = 10;

const int motor1Pin = 6;
const int motor2Pin = 5;

const int lockSensePin = A5;
const int spinSensePin = 4;
const int fireSensePin = 2;

const int motorMin = 30;
const int motorIdle = 35;
const int motorFire = 130;
const int motorMax = 150;

unsigned long prevMoveTime = 0;
unsigned long prevAccelTime = 0;
unsigned int waitTime = 10000;


unsigned int currentStepperSpeed = 0;
const unsigned long accelTime = 1000;
const unsigned long deccelTime = 500;

unsigned long currentAccelTime = accelTime;

bool accelling = false;
bool moving = false;

const unsigned int fireRateMax = 200*20/400; //steps per % of a second for faster motor
const unsigned int driveRatio = 3; //number of revs of kick per rev of drive
unsigned int driveRatioWorking = 0;

void setup() {
  pinMode(lockSensePin, INPUT);
  pinMode(spinSensePin, INPUT_PULLUP);
  pinMode(fireSensePin, INPUT_PULLUP);
  
  pinMode(beltStepperPin, OUTPUT);
  pinMode(kickStepperPin, OUTPUT);

  motor1.attach(motor1Pin);
  motor2.attach(motor2Pin);
  motor1.write(motorMax);
  motor2.write(motorMax);
  delay(2000);
  motor1.write(motorMin);
  motor2.write(motorMin);
  delay(2000);
  prevMoveTime = micros();
  prevAccelTime = micros();
}
bool revving = false;
bool firing = false;
void loop() {
  unsigned long current = micros();
  unsigned long moveTimePast = current - prevMoveTime;
  unsigned long accelTimePast = current - prevAccelTime;

  if(moving && (moveTimePast>=waitTime)){
    prevMoveTime += waitTime;
    if(moveTimePast>waitTime*16){
      prevMoveTime = current;
    }
    digitalWrite(kickStepperPin, HIGH);
    if(driveRatioWorking == driveRatio){
      digitalWrite(beltStepperPin, HIGH);
      driveRatioWorking = 0;
      delayMicroseconds(1);
      digitalWrite(beltStepperPin, LOW);
    }
    delayMicroseconds(1);
    driveRatioWorking++;
    digitalWrite(kickStepperPin, LOW);
  }
  if(accelling && (accelTimePast >= currentAccelTime)){
    prevAccelTime += currentAccelTime;
    if(accelTimePast>currentAccelTime*16){
      prevAccelTime = current;
    }
    if(currentAccelTime == accelTime){
      if(currentStepperSpeed == fireRateMax){
        accelling = false;
      } else {
        currentStepperSpeed++;
      }
    } else {
      if(currentStepperSpeed == 0){
        accelling = false;
      } else {
        currentStepperSpeed--;
      }
    }
    if(currentStepperSpeed != 0){
      moving = true;
      prevMoveTime = micros();
      waitTime = 10000/currentStepperSpeed;
    }else{
      moving = false;
    }
  }
  if(!revving && (digitalRead(spinSensePin) == LOW)){
    revving = true;
    motor1.write(motorIdle);
    motor2.write(motorIdle);
  }else if(revving && (digitalRead(spinSensePin) == HIGH)){
    revving = false;
    motor1.write(motorMin);
    motor2.write(motorMin);
  }
  if(!firing && (digitalRead(fireSensePin) == LOW)){
    firing = true;
    motor1.write(motorFire);
    motor2.write(motorFire);
    currentAccelTime = accelTime;
    accelling = true;
    prevAccelTime = micros();
    if(currentStepperSpeed<10){
      currentStepperSpeed=10;
      waitTime = 10000/currentStepperSpeed;
      moving = true;
      prevMoveTime = micros();
    }
  }else if(firing && (digitalRead(fireSensePin) == HIGH)){
    motor1.write(motorIdle);
    motor2.write(motorIdle);
    firing = false;
    if(currentStepperSpeed>0){
      currentAccelTime = deccelTime;
      accelling = true;
      prevAccelTime = micros();
    }
  }
}
