namespace :metrics do
  def logger
    require 'logger'
    logger = Logger.new(Rails.root.join("log/metrics.log"), "monthly")
  end

  desc "Generate all metrics"
  task :generate do
    # expects all metrics to have :generate tasks
    metrics = %w(sandi_meter)
    metrics.each do |metric|
      metric_rake_task = "metrics:#{metric}:generate"
      Rake::Task[metric_rake_task].invoke
    end
  end

  namespace :sandi_meter do
    sandi_pages_path = Rails.root.join('public/metrics/sandi_meter')

    desc "Generates/updates html pages for /metrics/sandi_meter"
    task :generate do
      # mms: using CLI because I could not find easy way to access anaylzer, for rails -> html, via code
      message = "Generating sandi_meter metrics at #{sandi_pages_path}"
      logger.info message
      # puts message
      `sandi_meter --graph --quiet --output-path "#{sandi_pages_path}"`

      # update assets for rails public dir
      index_file = sandi_pages_path.join('index.html')
      text = File.read(index_file)
      # add leading slash
      asset_path = '/metrics/sandi_meter/assets'
      new_contents = text.gsub(/href="assets/, %Q(href="#{asset_path}))
      new_contents = new_contents.gsub(/src="assets/, %Q(src="#{asset_path}))
      # write changes to index.html
      File.open(index_file, "w") {|file| file.puts new_contents }
    end

    desc "Clean html pages at #{sandi_pages_path}"
    task :clean do
      message = "Removing sandi_meter pages #{sandi_pages_path}"
      logger.info message
      # puts message
      FileUtils.rm_rf(sandi_pages_path)
    end
  end
end
