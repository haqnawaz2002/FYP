import processing.serial.*;

Serial myPort;
boolean irActive = false;  // Flag for IR sensor detection
boolean isDrawing = false; // Flag to determine if drawing should occur
float tiltAngle = 0;       // Tilt angle
float xPos = width / 2;    // Pointer x-position
float yPos = height / 2;   // Pointer y-position

float sensitivity = 0.1;   // Scaling factor to adjust sensitivity

void setup() {
  size(800, 600); // Size of the window
  background(255); // White background
  
  // List all serial ports and select the correct one
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600); // Adjust port index as needed
  
  myPort.bufferUntil('\n'); // Wait for complete line from Arduino
}

void draw() {
  // Draw the pointer (red dot)
  fill(255, 0, 0); // Red color for pointer
  ellipse(xPos, yPos, 10, 10); // Draw the pointer

  // If IR is active and tilt angle is within range, draw on canvas
  if (irActive && tiltAngle >= 100 && tiltAngle <= 150) {
    fill(0); // Black color for drawing
    ellipse(xPos, yPos, 5, 5); // Draw at pointer position
    isDrawing = true;
  } else {
    isDrawing = false;
  }
}

void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('\n'); // Read serial data as string
  if (data != null) {
    data = trim(data); // Clean up the data
    
    // Split the received data into parts
    String[] parts = split(data, ',');
    
    if (parts.length == 4) {
      irActive = parts[0].equals("1"); // IR sensor active if 1
      tiltAngle = float(parts[1]);     // Tilt angle from MPU6050
      float rawXPos = float(parts[2]); // Raw X position from MPU
      float rawYPos = float(parts[3]); // Raw Y position from MPU

      // Apply sensitivity scaling
      xPos += (rawXPos - xPos) * sensitivity;
      yPos += (rawYPos - yPos) * sensitivity;
    }
  }
}
