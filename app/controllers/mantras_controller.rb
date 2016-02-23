class MantrasController < ApplicationController
  skip_before_action :authenticate

  def refresh
    Mantra.reload
    redirect_to :root
  end

end
