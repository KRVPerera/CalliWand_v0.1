const int ledPin = 13;

void setup() {
  // put your setup code here, to run once:
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  Serial.begin(38400);
  Serial.print('a');
  char a = 'b';
  while (a != 'a'){
    a = Serial.read();
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(ledPin, LOW);
  delay(5000);
}
