class Song < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  has_many :notes

  def artist_name=(name)
    self.artist=Artist.find_or_create_by(name: name)
  end

  def artist_name
    if self.artist
      self.artist.name
    else
      nil
    end
  end

  def note_contents=(contents)

    contents.each do |note|
      self.notes << Note.create(content: note) if note != ""
    end
  end

  def note_contents
    arr = []
    self.notes.each do |n|
      arr << n.content
    end
    arr
  end

  def genre_name=(name)
    self.genre=Genre.find_or_create_by(name: name)
  end

  def genre_name
    self.genre.name
  end

end
