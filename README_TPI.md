# Polycon

## Models

Contiene las clases appointments y professionals, los cuales contienen las variables de instancias y los métodos necesarios para resolver los problemas planteados en commands. Contiene toda acción de listar, escribir, editar o eliminar un directorio o archivo (**a partir de la segunda entrega, la mayoría de ellas son llamados al módulo Store**).

## Commands

Contiene los módulos appoitments y professionals, los cuales contienen las clases que reprensentan a los métodos que deben resolver. Para su resolución, deben crear instancias de los objetos de models y llamar a los métodos que sean necesarios.
**En la segunda entrega, se agregó el módulo templates, con las clases encargadas de crear grillas de turnos tanto diarios como semanales**.

~~## Utils~~

~~Módulo con métodos auxiliares para ser llamados desde los commands de appointments y professionals. Entre ellos el método para posicionarse el el directorio .polycon y, en caso que no exista, crearlo, y el método que verifica que exista un profesional en específico.~~
**A partir de la segunda entrega, el módulo utils es reemplazado por el Store**

## Store

Módulo que contiene los métodos auxiliares para ser llamados desde los commands de appointments, professionals y templates. Entre ellos los métodos que formatean fechas, la creación, eliminación, edición y obtención de archivos, y la verificación de la existencia de los mismos.

## Professionals

- Se valida que el profesional pedido exista.

### Create

- No se pueden cargar 2 profesionales con el mismo nombre. En ese caso, permanece el primero y se notifica al crear el segundo.

- Los nombres de los directorios contendrán espacios.

### Delete

- No se puede eliminar a un profesional que tenga turnos pendientes. Como turnos pendientes se entiende a todos los turnos que todavía no pasaron (fecha posterior a la fecha actual).

### List

- Se chequea que existan profesionales en el sistema, antes de realizar el listado.

### Rename

- Al igual que en el create, el nombre nuevo del profesional no puede ser igual al nombre de otro profesional existente.

## Appointments

- Se valida que la fecha sea válida dependiendo lo que el método necesite, ya sea de tipo Date y DateTime.

- Los turnos se dan en bloques cada 20 minutos, siendo el inicio en los minutos 00, 20 y 40, y se considera que durarán el total de tiempo del bloque en el que se encuentren.

- Los turnos de un/a mismo/a profesional no se solaparán dentro de un mismo bloque (es decir, no existen sobreturnos)

- Se valida que el profesional pedido exista.

- Se valida que el turno al que se hace referencia exista.

- Tanto en la creación como en la reprogramación de un turno, se valida que su fecha no coincida con un turno cargado previamente y que sea posterior a la fecha actual (no se pueden cargar turnos para fechas que ya pasaron).

### Create

- Se crea el archivo turno con los datos apellido, nombre, teléfono y notas (opcional), en el orden indicado y con saltos de línea entre cada uno.

### Show

- Se muestran los datos del turno en el siguiente orden: profesional, nombre y apellido del paciente, teléfono, fecha y hora del turno, y notas (**el profesional y la fecha y hora del turno, fueron agregados en la segunda entrega**).

### Cancel

- La cancelación de un turno implica la eliminación física del archivo.

### CancelAll

- La cancelación de un turno implica la eliminación física del archivo.

- Solamente se cancelan los turnos que todavía no pasaron, es decir, aquellos en los cuales su fecha es posterior a la fecha actual. Con lo cual, los turnos "viejos" quedarían como un historial y el directorio podría eliminarse sin problemas.

### List

- En el caso de enviar por parámetro solamente el nombre del profesional, se lista el día y la hora de todos los turnos, sin importar cuándo se realizaron o se van a realizar.

- En el caso de enviar también una fecha específica, se lista el día y la hora de todos los turnos realizados ese día en particular.

### Edit

- En este caso, se crea una instancia del modelo de appointments en donde sus variables obtienen el valor del archivo a editar. Luego, se le envían todos los campos a editar, reemplazando así el valor de las variables de instancia. Finalmente, se guarda la edición al reescribir las nuevas variables sobre el archivo original.

## Templates

- Se valida que la fecha sea válida dependiendo.

- En el caso de querer filtrar por un profesional, se valida que el mismo exista.

- Todos los archivos creados tienen la terminación '.html'.

- Todos los archivos creados se guardan en el directorio "tables" dentro del root del usuario. 

### CreateDay

- En el caso de enviar por parámetro solamente la fecha, se obtienen los turnos de todos los profesionales para luego seleccionar solamente los que sean para dicha fecha.

- En el caso de enviar también un profesional específico, se obtienen los turnos de ese profesional para luego seleccionar solamente los que sean para dicha fecha.

- En ambos casos, se renderiza un template con los turnos seleccionados.

### CreateWeek

- La semana a mostrar va a ser la que contenga a la fecha enviada.

- Las semanas se inician en domingo y finalizan en sábado.

- Por ejemplo, en el caso de enviar la fecha 2021-10-28 (jueves), la semana a mostrar va a ser la comprendida entre el 2021-10-24 (domingo) y el 2021-10-30 (sábado).

- En el caso de enviar por parámetro solamente la fecha, se obtienen los turnos de todos los profesionales para luego seleccionar solamente los que sean para dicha semana.

- En el caso de enviar también un profesional específico, se obtienen los turnos de ese profesional para luego seleccionar solamente los que sean para dicha semana.

- En ambos casos, se renderiza un template con los turnos seleccionados.