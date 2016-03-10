class MakeNeutralObservationsZero < ActiveRecord::Migration
  def change
    Observation.all.each do |observation|
      next if !observation.membership || !observation.user
      status_in = observation.read_attribute("status")
      if status_in === 3 || status_in.nil?
        status_out = 0
      else
        status_out = status_in + 1
      end
      observation.update(status: status_out)
    end
  end
end
