# nixie

![Nixie photo](https://github.com/yetifrisstlama/nixie/raw/master/cad/pic.jpg)

My exercise in OpenScad.
a HP 5245L frequency counter had to die for this ...

# Lessons learned the hard way
Murphy was strong on that one ...

  * Nixie pins are fragile and don't like too tight sockets. RIP 2 tubes ...
  * The HV5530 in a PQFP package has a different pinout than the one in a PLCC package. Fixed it with tons of botch wire :weary:
  * Didn't notice that the nixie tube datasheet shows the pinout from the bottom :unamused:. Fixed it with a lot more botch wire
  * Feel free to re-do the layout in kicad ...
  * Magnet wire insulation didn't hold up to 180 V. Killed 2xESP32 that way. Fixed it with conformal coating
  * Keep conformal coating away from push buttons, it disables them
  

