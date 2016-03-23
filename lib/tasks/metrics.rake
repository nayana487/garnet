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
