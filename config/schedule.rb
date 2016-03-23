every :day, :at => '1am' do
  rake "metrics:generate"
end

every :day, :at => '10am' do
  rake "attendance:mark_absent"
end
