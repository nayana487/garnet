class Mantra
  @@all = []

  def self.reload
    @@all = File.read("./vendor/mantras.html").chomp.split("\n")
  end

  def self.all
    if @@all.empty? then Mantra.reload end
    return @@all
  end

end
