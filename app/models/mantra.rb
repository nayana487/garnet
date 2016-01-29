class Mantra
  @@all = []

  def self.reload
    puts "Duck..." * 10
    puts "Fetching mantras..."
    begin
      @@all = JSON.parse(HTTParty.get("http://rubberduck.robertakarobin.com/all").body)
    rescue
      @@all = ["Is your blue elephant running?"];
    end
  end

  def self.all
    if @@all.empty? then Mantra.reload end
    return @@all
  end

end
