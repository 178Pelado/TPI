class AppointmentsController < ApplicationController
  load_and_authorize_resource :professional
  load_and_authorize_resource :appointment, through: :professional

  # GET /appointments or /appointments.json
  def index
    if filter_params[:date].present?
      @appointments = @professional.appointments.filter_by_date(filter_params[:date])
    else
      @appointments = @professional.appointments
    end
    @f = filter_params[:date]
  end

  def index_date
    @appointments = @professional.appointments.first
    format.html { redirect_to [@professional, @appointment], notice: "Appointment was successfully canceled." }
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = @professional.appointments.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to [@professional, @appointment], notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to [@professional, @appointment], notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to [@professional, @appointment], notice: "Appointment was successfully canceled." }
      format.json { head :no_content }
    end
  end

  private
    def filter_params
      if params.key?(:filters)
        params.require(:filters).permit(:date)
      else
        {}
      end
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:date, :name, :surname, :phone, :notes)
    end
end
