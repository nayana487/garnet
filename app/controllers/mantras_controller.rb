class MantrasController < ApplicationController
  skip_before_action :authenticate

  def refresh
    Mantra.reload
    index
  end

  def random
    render json: {success: true, message: Mantra.all.sample}
  end

  def index
    render json: Mantra.all
  end

end
