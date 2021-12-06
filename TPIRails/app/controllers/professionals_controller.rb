class ProfessionalsController < ApplicationController
  load_and_authorize_resource

  # GET /professionals or /professionals.json
  def index
    @professionals = Professional.all
  end

  # GET /professionals/1 or /professionals/1.json
  def show
  end

  # GET /professionals/new
  def new
  end

  # GET /professionals/1/edit
  def edit
  end

  # POST /professionals or /professionals.json
  def create
    @professional = Professional.new(professional_params)

    respond_to do |format|
      if @professional.save
        format.html { redirect_to @professional, notice: "Professional was successfully created." }
        format.json { render :show, status: :created, location: @professional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professionals/1 or /professionals/1.json
  def update
    respond_to do |format|
      if @professional.update(professional_params)
        format.html { redirect_to @professional, notice: "Professional was successfully updated." }
        format.json { render :show, status: :ok, location: @professional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professionals/1 or /professionals/1.json
  def destroy
    respond_to do |format|
      if @professional.destroy
        format.html { redirect_to professionals_url, notice: "Professional was successfully destroyed." }
      else
        format.html { redirect_to professionals_url, notice: "No se pudo eliminar al profesional, debido a que tiene turnos pendientes." }
      end
    end
  end

  def cancel_all_appointments
    @professional.appointments.destroy_all
    respond_to do |format|
      format.html { redirect_to professional_appointments_path(@professional), notice: "Appointment was successfully canceled." }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def professional_params
      params.require(:professional).permit(:name)
    end
end
