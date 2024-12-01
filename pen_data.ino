#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;
int16_t ax, ay, az, gx, gy, gz;
const int irPin = 3; // IR sensor connected to digital pin 3

// Define the update interval (in milliseconds) for the accelerometer data
const unsigned long updateInterval = 20; // 50 Hz = 1000 ms / 50
unsigned long previousMillis = 0;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  mpu.initialize(); // Initialize MPU6050
  pinMode(irPin, INPUT); // Set IR pin as input
}

void loop() {
  unsigned long currentMillis = millis();

  // Check if it's time to update the accelerometer data
  if (currentMillis - previousMillis >= updateInterval) {
    previousMillis = currentMillis;

    int irValue = digitalRead(irPin); // Read the IR sensor state

    // Get accelerometer and gyroscope readings
    mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

    // Send data over Serial in comma-separated format
    Serial.print(ax); Serial.print(",");
    Serial.print(ay); Serial.print(",");
    Serial.print(az); Serial.print(",");
    Serial.print(gx); Serial.print(",");
    Serial.print(gy); Serial.print(",");
    Serial.print(gz); Serial.print(",");
    Serial.println(irValue); // Send IR status at the end
  }
}
