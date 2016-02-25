#this class performs CRUD operations on the library file
require 'json'
require 'lita'
require_relative 'library_entry'

module Lita
  module Handlers
    class LinkLibrary < Handler
      
      TITLE = /[\w\s\,\.\-\/:–]+/
      LINK = /(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?/
      DESCRIPTION = /[\w\s\,\.\-\/:–]+/
      
      route(
        /^(random read)$/i, 
        :random_read_command, 
        command: true, 
        help: {'random read' => 'Returns a random entry from the lita link library.'}
      )
      
      route(
        /^(give me a gooder)$/i, 
        :read_best_entries_command, 
        command: true, 
        help: {'give me a gooder' => 'Returns top 3 entries from the lita link library.'}
      )
      
      route(
        /^(list library)$/i, 
        :list_library_command, 
        command: true, 
        help: {'list library' => 'Returns entire lita link library.'}
      )
      
      route(
        /^(?:want to read)\s(#{TITLE.source})$/i, 
        :want_to_read_command, 
        command: true, 
        help: {'want to read TITLE' => 'Returns the entry from lita link library with that TITLE.'}
      ) 
        
      route(
        /^(?:add read)\s(#{LINK.source})\s(#{TITLE.source})\s(#{DESCRIPTION.source})$/i, 
        :add_read_command, 
        command: true,
        restrict_to: :link_library_admins, 
        help: {'add read LINK TITLE DESCRIPTION' => 'Adds a new entry in thelita link library '+ 
        'with that LINK, TITLE and DESCRIPTION attributes.'}
      )
      route(
        /^(remove read)\s(#{TITLE.source})$/i, 
        :remove_read_command, 
        command: true, 
        restrict_to: :link_library_admins,
        help: {
        'remove read TITLE' => 'Removes the entry from lita link library with that TITLE.'}
      ) 
    
      def random_read_command(response)
        response.reply random_read_entry
      end
      
      def read_best_entries_command(response)
        response.reply read_best_entries
      end
      
      def list_library_command(response)
        response.reply list_library
      end
      
      def want_to_read_command(response)
        title = response.matches.first[0]
        response.reply read_entry(title)
      end
      
      def add_read_command(response)
        link = response.matches.first[0]
        title = response.matches.first[5]
        description = response.matches.first[6]
        response.reply save_new_entry(link, title, description)
      end
      
      def remove_read_command(response)
        title = response.matches.first[0]
        response.reply delete_entry(title)
      end
      
      def file_writer (filename, entries)
        open(filename, 'w') do |file|
          file.truncate(0)
          file.write entries.to_json
        end
      end
    
      def save_new_entry (link, title, description) # allows a librarian to save a new entry in the library
        file = File.read 'library.json'
        hash_array = JSON.parse(file)
        entry_exists = false
        hash_array.each do |entry|
          if entry.has_value?(title)
            entry_exists = true
          end
        end
        if entry_exists
          return "That title already exists in the DB. Please choose another one"
        else
          new_entry = {"link" => link, "title" => title, "description" => description, "number_of_downloads" => 0}
          hash_array.push new_entry
          file_writer 'library.json', hash_array
          return "The entry #{title} wass added in the library!"
        end
      end
    
      def delete_entry (title) # allows a librarian to delete an entry from the library
        file = File.read 'library.json'
        hash_array = JSON.parse(file)
        entries_counter = 0
        hash_array.each do |entry|
          if entry.has_value?(title)
            hash_array.reject! {|entry| entry.has_value?(title)}
            return "The entry with the title: #{title} was deleted"
            file_writer 'library.json', hash_array
          else
            entries_counter +=1
          end
        end
        if entries_counter==hash_array.length
          response = "No entry with the title #{title} can be found in the library"
        end
      end
    
      def read_entry (entry_title) # returns an entry with the specified title from the library
        file = File.read 'library.json'
        hash_array = JSON.parse(file)
        entries_counter = 0
        hash_array.each do |entry|
          if entry.has_value?(entry_title)
            return "#{entry_title} | #{entry['link']} | #{entry['number_of_downloads']} reads | #{entry['description']}"
            entry['number_of_downloads']+=1
            file_writer 'library.json', hash_array
          else
            entries_counter += 1
          end
        end
        if entries_counter==hash_array.length
          return "No entry entitled #{entry_title} can be found in the library DB!"
        end
      end
    
      def random_read_entry # returns a random entry from the library
        file = File.read 'library.json'
        hash_array = JSON.parse(file)
        entry = hash_array.sample
        return "Random read: #{entry['title']} | #{entry['link']} | #{entry['number_of_downloads']} reads | #{entry['description']}"
      end
    
      def read_best_entries # returns the top 3 downloaded entries from the library
        file = File.read 'library.json'
        hash_array = JSON.parse(file)
        hash_array.sort! {|a1, a2| a1['number_of_downloads'] <=> a2['number_of_downloads']}
        for i in 0..2
          "#{hash_array[i]['title']} | #{hash_array[i]['link']} | #{hash_array[i]['number_of_downloads']} reads | #{hash_array[i]['description']}\n"
        end
      end
    
      def list_library # returns the entire library
        file = File.read 'library.json'
        hash_array = JSON.parse(file)
        hash_array.each do |entry|
          library_entry = LibraryEntry.new entry['link'], entry['title'], entry['description'], entry['number_of_downloads']
          return "#{library_entry['title']} | #{library_entry['link']} | #{library_entry['number_of_downloads']} reads | #{library_entry['description']}\n"
        end
      end
      
    end
    
    Lita.register_handler(LinkLibrary)
  end
end
