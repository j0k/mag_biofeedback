// Master Gain with current value: 4.0 dB (range: -80.0 - 6.0206)
// Mute Control with current value: False
// Balance with current value: 0.0  (range: -1.0 - 1.0)
// Pan with current value: 0.0  (range: -1.0 - 1.0)

// operations 

float gainToVolume(float vol){
  float m = -30;
  float M = 5;
  
  return (m + (M - m) * vol);
}
