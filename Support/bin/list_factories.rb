#!/usr/bin/env ruby -W0

require File.join(File.dirname(__FILE__), '..', 'lib', 'search_utilities')
require File.join(File.dirname(__FILE__), '..', 'lib', 'rails_bundle_tools')

module TextMate
  class ListFactories
    def run!(style='factory')
      if style == 'factory_girl'
        trigger = 'Facg'
        prepend = 'FactoryGirl.${1:build}(:'
        append = '$2)$0'
      else
        trigger = 'Fac'
        prepend = 'Factory(:'
        append = '$1)$0'
      end
      
      search_term = TextMate::UI.request_string(:title => "Find Factory", :prompt => "Factory Name")
      all_names = collect_factory_names
      
      matches = array_sorted_search(all_names, search_term)
            
      if matches.empty?
        print trigger
        TextMate::UI.tool_tip "No factories found matching '#{search_term}'"
      elsif matches.size == 1
        print "#{prepend}#{matches.first}#{append}"
      else
        selected = TextMate::UI.menu(matches)
        if selected.nil?
          print trigger
        else
          print "#{prepend}#{matches[selected]}#{append}"
        end
      end
    end
    

    def collect_factory_names
      names = []
      self.each_factory_line do |line|
        result = line.match(%r!Factory\.define\(?\s*:(\w+).*\)?!)
        result = line.match(%r!factory\s*\(?\s*:(\w+).*\)?!) if result.nil? or result[1].nil?
        names << result[1] if result
      end
      return names
    end
    
    def each_factory_line
      factory_files = Dir.glob(File.join(RailsPath.new.rails_root.to_s, "test", "factories", "**/**/*.rb")) + Dir.glob(File.join(RailsPath.new.rails_root.to_s, "spec", "factories", "**/**/*.rb"))
      seen_files = {}
      factory_files.each do |file|
        filename = File.basename(file)
        next if seen_files[filename]
        seen_files[filename] = true
        File.foreach(file) do |line|
          yield line
        end
      end
    end
  end    
end