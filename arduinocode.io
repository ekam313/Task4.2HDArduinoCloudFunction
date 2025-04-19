#include <WiFiNINA.h>
#include <Firebase_Arduino_WiFiNINA.h>

#define FIREBASE_HOST "trafficlightcalling-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "mRXXQExOUFayVEKZ1yR2zgojEcnVCKaG6EfX63jE"
#define WIFI_SSID "Ekamjot’s iPhone"
#define WIFI_PASSWORD "Ekam1233"

FirebaseData firebaseData;

const int redPin = 4;
const int greenPin = 5;
const int yellowPin = 6;

void setup() {
  Serial.begin(115200);

  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(yellowPin, OUTPUT);

  Serial.print("Connecting to WiFi...");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi Connected!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH, WIFI_SSID, WIFI_PASSWORD);
  Firebase.reconnectWiFi(true);
}

void loop() {
  checkLED("/leds/red", "red", redPin);
  checkLED("/leds/green", "green", greenPin);
  checkLED("/leds/yellow", "yellow", yellowPin);

  delay(1000); // check every second
}
// Function to check LED status from Firebase
void checkLED(const String& path, const String& color, int pin) {
  if (Firebase.getString(firebaseData, path)) {
    String value = firebaseData.stringData();
    digitalWrite(pin, value == color ? HIGH : LOW);
    Serial.println(color + " LED State: " + value);
  } else {
    Serial.println("Error reading " + path + ": " + firebaseData.errorReason());
  }
}

