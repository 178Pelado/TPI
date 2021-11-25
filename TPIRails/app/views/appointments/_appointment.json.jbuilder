json.extract! appointment, :id, :date, :name, :surname, :phone, :notes, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
