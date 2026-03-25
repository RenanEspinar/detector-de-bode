# detector-de-bode
Herramienta didáctica en MATLAB para visualizar e interpretar diagramas de Bode de forma intuitiva.
# detector-de-bode

Herramienta didáctica en MATLAB para visualizar e interpretar diagramas de Bode de forma intuitiva.

---

## ¿Qué hace?

Este script permite:

- Generar el diagrama de Bode de un sistema dinámico
- Mostrar magnitud y fase de forma clara
- Marcar la frecuencia de corte aproximada
- Interpretar visualmente rapidez y desfase
- Explicar el comportamiento del sistema de manera didáctica

---

## Idea clave

> "A mayor frecuencia, el sistema responde menos y responde más tarde"

- La **magnitud** indica qué tan fuerte responde el sistema
- La **fase** indica cuánto se retrasa la salida respecto a la entrada

---

## Uso

1. Abre MATLAB
2. Ejecuta el script
3. Define tu función de transferencia en la sección:

```matlab
s = tf('s');
G = ...

Simple 
G = 1/((s+1)*(s+2)*(s+3));
Motor DC 
R = 2;
J = 0.02;
Kt = 0.1;
L = 0.5;
b = 0.01;
Ke = 0.1;
G = Kt / (L*J*s^2 + (R*J + L*b)*s + (R*b + Kt*Ke));
