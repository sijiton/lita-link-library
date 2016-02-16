# this class represents the Model for the entries available in the library.json

class LibraryEntry

  attr_accessor :link, :title, :description, :number_of_downloads
  
  def initialize(*args)
    @link = args[0]
    @title = args[1]
    @description = args[2]
    @number_of_downloads = args[3]
  end

end