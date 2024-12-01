import processing.serial.*;

Serial myPort;  // Create object from Serial class
float xPos, yPos;  // Variables to store current position data
float dotSize = 30;  // Increased size of the dot for better visibility
ArrayList<PVector> trail = new ArrayList<PVector>();  // ArrayList to store trail points
String[] lines;  // Array to store lines read from the file
int lineIndex = 0;  // Index to track the current line being read

void setup() {
  size(800, 600);  // Set the window size
  ellipseMode(CENTER);  // Set ellipse mode to draw from center
  xPos = width / 2;  // Initialize dot position in the center horizontally
  yPos = height / 2;  // Initialize dot position in the center vertically
  
  // Load sensor data from file into array
  lines = loadStrings("/home/acer/Desktop/semester 8/fyp/haqni.txt");
  
  // Start reading sensor data from the first line
  if (lines.length > 0) {
    parseSensorData(lines[0]);
  }
}

void draw() {
  background(255);  // Clear the screen
  
  // Draw trail lines
  stroke(0);  // Set line color to black
  for (int i = 1; i < trail.size(); i++) {
    PVector currentPos = trail.get(i);
    PVector prevPos = trail.get(i - 1);
    line(currentPos.x, currentPos.y, prevPos.x, prevPos.y);
  }
  
  // Draw the filled dot at current position
  fill(0);  // Set dot fill color to black
  ellipse(xPos, yPos, dotSize, dotSize);  // Draw the dot at xPos, yPos
  
  // Move to the next line of sensor data every frame
  lineIndex = (lineIndex + 1) % lines.length;
  parseSensorData(lines[lineIndex]);
  
  // Introduce a delay of 100 milliseconds (adjust as needed)
  delay(100);
}

void parseSensorData(String data) {
  if (data != null && !data.isEmpty()) {  // Check if data is not null or empty
    data = data.trim();  // Remove leading/trailing whitespaces
    String[] values = data.split(",");  // Split the data by comma
    if (values.length == 6) {  // Check if all values are received
      try {
        float ax = Float.parseFloat(values[0]);  // Use x-axis accelerometer data
        float ay = Float.parseFloat(values[1]);  // Use y-axis accelerometer data
        
        // Calculate new dot position with accelerometer data
        xPos = constrain(map(ax, -16000, 16000, 0, width), dotSize / 2, width - dotSize / 2);
        yPos = constrain(map(ay, -16000, 16000, 0, height), dotSize / 2, height - dotSize / 2);
        
        // Store current position in trail
        PVector currentPos = new PVector(xPos, yPos);
        trail.add(currentPos);
        
        // Limit the trail length
        if (trail.size() > 100) {
          trail.remove(0);
        }
      } catch (NumberFormatException e) {
        println("Error parsing data: " + e.getMessage());
      }
    }
  }
}
