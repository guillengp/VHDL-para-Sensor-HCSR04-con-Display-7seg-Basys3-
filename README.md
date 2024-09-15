Este proyecto, hecho para la BASYS3, implementa un sensor ultrasónico Arduino con el display 7seg
de la BASYS3, apareciendo la distancia en [cm] en el display.
El programa posee tambien un botón de Reset en el Botón central de la placa y su programación 
desecha las mediciones cuando el Echo se alarga demasiado (23.3ms).
1. El archivo top.vhd es la capa que junta el resto de archivos.
2. El archivo HCSR04.vhd es la Maquina de estados del sensor que genera el pulso de Trigger, mide,
   y calcula la distancia para el tiempo del Echo.
3. El archivo Distance_Calc.vhd recoge la señal Distance del HCSR04.vhd y la divide por digitos.
4. El archivo Display.vhd recoge los digitos generados y los muestra secuencialmente en el Display.
5. El archivo Basys3.xdc son las restricciones necesarias para la placa específica BASYS3
