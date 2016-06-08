class Mantra
  @@all = []
  cattr_accessor :last_updated

  def self.reload
    begin
      raw =  HTTParty.get("https://raw.githubusercontent.com/ga-wdi-lessons/wdi-mantras/master/readme.md")
      @@all = raw.gsub(/^-\s*/, "").split(/[\n\r]/)
      @@last_updated = Time.now
    rescue
      @@all = ["Is your blue elephant running?"];
      @@last_updated = Time.now
    end
  end

  def self.all
    if @@all.empty? || (Time.now - 1.hour > @@last_updated)
      Mantra.reload
    end
    return @@all
  end
end
