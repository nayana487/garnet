namespace :sandi_meter do
  desc "Generates/updates html pages at /metrics/sandi_meter"
  task :generate do
    # mms: using CLI because I could not find easy way to access anaylzer, for rails -> html, via code
    output_path = Rails.root.join('public/metrics/sandi_meter')
    puts "Generating #{output_path}"
    `sandi_meter --graph -q --output-path "#{output_path}"`
  end
end
