# this class represents the Model for the entries available in the librarian.json

class Librarian

  attr_accessor :username, :permissions

  def initialize(*args)
    #@id = args[0]
    @username = args[0]
    @permissions = args[1]
  end

end
