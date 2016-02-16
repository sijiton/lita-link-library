#this class performs CRUD operations on both the library and librarians files
require 'json'
require_relative 'library_entry'
require_relative 'librarian'

class LinkLibrary

  @@library_file = 'library.json'
  @@librarians_file = 'librarians.json'

  def initialize

  end

  def file_writer (filename, entries)
    open(filename, 'w') do |file|
      file.truncate(0)
      file.write entries.to_json
    end
  end

  def save_new_librarian (username, permissions) # allows a master-librarian admin to save a new librarian into librarians
    file = File.read @@librarians_file
    hash_array = JSON.parse(file)
    librarian_exists = false
    hash_array.each do |entry|
      if entry.has_value?(username)
        librarian_exists = true
      end
    end
    if librarian_exists
      pp "That user already exists as a librarian!"
      else
        new_librarian = {"username" => username, "permissions" => permissions}
        hash_array.push new_librarian
        file_writer @@librarians_file, hash_array
    end
  end

  def delete_librarian (librarian_name) # allows a master-librarian to delete a librarian from librarians
    file = File.read @@librarians_file
    hash_array = JSON.parse(file)
    entries_counter = 0
    hash_array.each do |entry|
      if entry.has_value?(librarian_name)
        hash_array.reject! {|entry| entry.has_value?(librarian_name)}
        pp "The librarian with #{entry.key(librarian_name)}: #{librarian_name} was deleted"
        file_writer @@librarians_file, hash_array
      else
        entries_counter +=1
      end
    end
    if entries_counter==hash_array.length
      pp "No username #{librarian_name} can be found in the librarians DB"
    end
  end

  def list_librarians # returns a list of all the librarians
    file = File.read @@librarians_file
    hash_array = JSON.parse(file)
    hash_array.each do |entry|
      librarian = Librarian.new entry['username'], entry['permissions']
      pp "Librarian's name: #{librarian.username}; his permissions: #{librarian.permissions}"
    end
  end

def save_new_entry (link, title, description) # allows a librarian to save a new entry in the library
    file = File.read @@library_file
    hash_array = JSON.parse(file)
    entry_exists = false
    hash_array.each do |entry|
      if entry.has_value?(title)
        entry_exists = true
      end
    end
    if entry_exists
        pp "That title already exists in the DB. Please choose another one"
      else
        new_entry = {"link" => link, "title" => title, "description" => description, "number_of_downloads" => 0}
        hash_array.push new_entry
        file_writer @@library_file, hash_array
    end
  end

  def delete_entry (title) # allows a librarian to delete an entry from the library
    file = File.read @@library_file
    hash_array = JSON.parse(file)
    entries_counter = 0
    hash_array.each do |entry|
      if entry.has_value?(title)
        hash_array.reject! {|entry| entry.has_value?(title)}
        pp "The entry with the title: #{title} was deleted"
        file_writer @@library_file, hash_array
      else
        entries_counter +=1
      end
    end
    if entries_counter==hash_array.length
      pp "No entry with the title #{title} can be found in the library"
    end
  end

  def read_entry (entry_title) # returns an entry with the specified title from the library
    file = File.read @@library_file
    hash_array = JSON.parse(file)
    entries_counter = 0
    hash_array.each do |entry|
      if entry.has_value?(entry_title)
        pp "The entry with the title #{entry_title}: #{entry}"
        entry['number_of_downloads']+=1
        pp entry
        file_writer @@library_file, hash_array
      else
        entries_counter += 1
      end
    end
    if entries_counter==hash_array.length
      pp "No entry entitled #{entry_title} can be found in the library DB"
    end
  end

  def random_read_entry # returns a random entry from the library
    file = File.read @@library_file
    hash_array = JSON.parse(file)
    pp hash_array.sample
  end

  def read_best_entries # returns the top 3 downloaded entries from the library
    #downloads_array = Array.new
    file = File.read @@library_file
    hash_array = JSON.parse(file)
    hash_array.sort! {|a1, a2| a1['number_of_downloads'] <=> a2['number_of_downloads']}
    pp "The top 3 most downloaded links are: "
    for i in 0..2
      pp hash_array[i]
    end
  end

  def list_library # returns the entire library
    file = File.read @@library_file
    hash_array = JSON.parse(file)
    hash_array.each do |entry|
      library_entry = LibraryEntry.new entry['link'], entry['title'], entry['description'], entry['number_of_downloads']
      pp "The entry with the link: #{library_entry.link} and title: #{library_entry.title} "+
      "has the following description: #{library_entry.description} and # of downloads: #{library_entry.number_of_downloads}"
    end
  end

end