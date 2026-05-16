# Contribuir a Organización del Computador - BubbleSort

¡Gracias por tu interés en colaborar! Este proyecto fue desarrollado como un trabajo práctico universitario, pero cualquier mejora, optimización de código o corrección de errores es más que bienvenida para hacer que esta implementación en bajo nivel sea aún más eficiente.

## Cómo Contribuir

1. Haz un **Fork** del repositorio.
2. Crea tu rama con la nueva mejora: `git checkout -b feature/nueva-optimizacion`.
3. Realiza tus cambios y haz un commit: `git commit -m "Optimizar bucle principal de BubbleSort"`.
4. Sube tu rama: `git push origin feature/nueva-optimizacion`.
5. Abre un **Pull Request**.

## Ideas para Contribuir

- **Optimización del Algoritmo:** Implementar una bandera (*flag*) de control para detectar si el arreglo ya está ordenado y cortar la ejecución antes (BubbleSort optimizado).
- **Mejoras en el Rendimiento:** Reducir la cantidad de accesos a memoria (`Memory Access`) priorizando el uso de registros para los intercambios (*swaps*).
- **Formatos de Entrada:** Agregar soporte para procesar archivos `.dat` con diferentes tamaños de estructura o manejar errores si el archivo está vacío o corrupto.
- **Visualización en Consola:** Mejorar la interfaz gráfica en texto para mostrar de forma más clara o animada cómo se van moviendo los elementos en cada pasada.
- **Refactor de Código:** Modularizar el archivo `bubbleSort.asm` separando la lógica de ordenamiento de las rutinas de entrada/salida (Lectura de archivos y pasadas por pantalla).

## Consejos para el Desarrollo

- **Gestión de la Pila (Stack):** Si modificas o agregas subrutinas, asegúrate de mantener el balance de la pila (`push` y `pop` emparejados) para evitar desbordamientos o comportamientos indefinidos al retornar (`ret`).
- **Uso de Registros:** Revisa qué registros son seguros de usar (volátiles vs. no volátiles) según la convención de llamadas que esté utilizando el proyecto.
- **Estructura del Archivo:** Mantén el código bien segmentado respetando las secciones estándar de Assembly (ej. `.data` para variables y cadenas, `.text` para las instrucciones del programa).

¡Muchas gracias por tu colaboración! 🎉
