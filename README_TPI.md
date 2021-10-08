# Polycon

## Models

Contiene las clases appointments y professionals, los cuales contienen las variables de instancias y los métodos necesarios para resolver los problemas planteados en commands. Contiene toda acción de posicionarse, escribir, editar o eliminar un directorio o archivo.

## Commands

Contiene los módulos appoitments y professionals, los cuales contienen las clases que reprensentan a los métodos que deben resolver. Para su resolución, deben crear instancias de los objetos de models y llamar a los métodos que sean necesarios

## Utils

Módulo con métodos auxiliares para ser llamados desde los commands de appointments y professionals. Entre ellos el método para posicionarse el el directorio .polycon y, en caso que no exista, crearlo, y el método que verifica que exista un profesional en específico.

## Professionals

Se valida que el profesional pedido exista.

### Create

No se pueden cargar 2 profesionales con el mismo nombre. En ese caso, permanece el primero y se notifica al crear el segundo.

Los nombres de los directorios contendrán espacios.

### Delete

No se puede eliminar a un profesional que tenga turnos pendientes. Como turnos pendientes se entiende a todos los turnos que todavía no pasaron (fecha posterior a la fecha actual).

### Rename

Al igual que en el create, el nombre nuevo del profesional no puede ser igual al nombre de otro profesional existente.

## Appointments

Se valida que la fecha sea válida dependiendo lo que el método necesite, ya sea de tipo Date y DateTime.

Se valida que el profesional pedido exista.

Se valida que el turno al que se hace referencia exista.

Tanto en la creación como en la reprogramación de un turno, se valida que su fecha no coincida con un turno cargado previamente y que sea posterior a la fecha actual (no se pueden cargar turnos para fechas que ya pasaron).

### Create

Se crea el archivo turno con los datos apellido, nombre, teléfono y notas (opcional), en el orden indicado y con saltos de línea entre cada uno.

### Show

Se muestran los datos del turno en el orden indicado previamente (apellido, nombre, teléfono y notas).

### Cancel

La cancelación de un turno implica la eliminación física del archivo.

### CancelAll

La cancelación de un turno implica la eliminación física del archivo.

Solamente se cancelan los turnos que todavía no pasaron, es decir, aquellos en los cuales su fecha es posterior a la fecha actual. Con lo cual, los turnos "viejos" quedarían como un historial y el directorio podría eliminarse sin problemas.

### List

En el caso de enviar por parámetro solamente el nombre del profesional, se lista el día y la hora de todos los turnos, sin importar cuándo se realizaron o se van a realizar.

En el caso de enviar también una fecha espefícica, se lista el día y la hora de todos los turnos realizados ese día en particular.

### Edit

En este caso, se crea una instancia del modelo de appointments en donde sus variables obtienen el valor del archivo a editar. Luego, se le envían todos los campos a editar, reemplazando así el valor de las variables de instancia. Finalmente, se guarda la edición al reescribir las nuevas variables sobre el archivo original.