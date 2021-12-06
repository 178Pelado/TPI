# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'consulta@gmail.com', password: '123456', role: 0)
User.create(email: 'asistencia@gmail.com', password: '123456', role: 1)
User.create(email: 'admin@gmail.com', password: '123456', role: 2)

professionals = Professional.create([
  { name: "Felipe Mosqueira" },
  { name: "Felip Mosqueir" },
  { name: "Feli Mosquei" },
])

Appointment.create(
  professional_id: 1,
  name: "Feli",
  surname: "Mosqueira",
  phone: "123456",
  date: DateTime.strptime("12/8/2021 16:00", "%m/%d/%Y %H:%M"),
)
Appointment.create(
  professional_id: 2,
  name: "Feli",
  surname: "Mosqueira",
  phone: "123456",
  date: DateTime.strptime("12/8/2021 16:20", "%m/%d/%Y %H:%M"),
)
Appointment.create(
  professional_id: 3,
  name: "Feli",
  surname: "Mosqueira",
  phone: "123456",
  date: DateTime.strptime("12/8/2021 16:40", "%m/%d/%Y %H:%M"),
)
Appointment.create(
  professional_id: 1,
  name: "Felipe",
  surname: "Mosqueira",
  phone: "123456",
  date: DateTime.strptime("12/8/2021 19:00", "%m/%d/%Y %H:%M"),
)
Appointment.create(
  professional_id: 2,
  name: "Felipe",
  surname: "Mosqueira",
  phone: "123456",
  date: DateTime.strptime("12/8/2021 19:20", "%m/%d/%Y %H:%M"),
)
Appointment.create(
  professional_id: 3,
  name: "Felipe",
  surname: "Mosqueira",
  phone: "123456",
  date: DateTime.strptime("12/8/2021 19:40", "%m/%d/%Y %H:%M"),
)