class GridsController < ApplicationController
  load_and_authorize_resource

  def new
    @grid = Grid.new()
  end

  def export
    @grid = Grid.new(grids_params)
    if @grid.valid?
      if not grids_params[:professional].blank?
        @professional = Professional.find(@grid.professional)
      end
      if @grid.type == "0"
        filename = helpers.grilla_de_un_dia(@grid.date, @professional)
      else
        filename = helpers.grilla_de_una_semana(@grid.date, @professional)
      end
      send_file(Rails.root.join("tmp/#{filename}.html"))
      #redirect_to @professional, notice: "Grid was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def grids_params
      params.require(:form_grid).permit(:professional, :date, :type)
    end
end