class Mantra
  @@all = []

  def self.reload
    begin
      @@all = JSON.parse(File.read(Rails.root + "public/mantras.json"))
    rescue
      @@all = ["Is your blue elephant running?"];
    end
  end

  def self.all
    Mantra.reload if @@all.empty?
    return @@all
  end
end
