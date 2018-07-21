# nixie

![Nixie photo](https://github.com/yetifrisstlama/nixie/raw/master/cad/pic.jpg)

My exercise in OpenScad.
a HP 5245L frequency counter had to die for this ...

# Lessons learned the hard way
Murphy was strong on this one ...

  * Nixie pins are fragile and don't like too tight sockets. RIP 2 tubes ...
  * The HV5530 in a PQFP package has a different pinout than the one in a PLCC package. Fixed it with tons of botch wire :weary:
  * Didn't notice that the nixie tube datasheet shows the pinout from the bottom :unamused:. Fixed it with a lot more botch wire
  * Feel free to re-do the layout in kicad ...
  * Magnet wire insulation didn't hold up to 180 V. Killed 2 x ESP32 that way. Fixed it with conformal coating
  * Didn't keep conformal coating away from push buttons, it disabled them
  * Hole pattern between PCB and 3D print was off by ~ 3 mm due to a typo in the 3D model. Fixed it by bending the 3D printed part with a hot air gun
  * Had to cut some of the 3D printed stand-offs and the ESP32 PCB antenna to make it all fit
  
  

