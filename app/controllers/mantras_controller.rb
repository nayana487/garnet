class MantrasController < ApplicationController
  skip_before_action :authenticate

  def all
    render json: Mantra.all
  end

  def reload
    Mantra.reload
    all
  end

  def one
    render json: {mantra: Mantra.all.sample}
  end

end
